class OfficeCalculatorController < ApplicationController
    before_action :load_calculator_config
    before_action :set_current_step, only: [:index, :start, :next_step, :previous_step]
    before_action :load_or_create_session, except: [:index]

    def index
        session[:current_step] = 'start'
        @current_step = 'start'
    end

    def start
        @current_step = 1
        update_cache(current_step: @current_step)
        set_questions
        set_active_locations
        render_step
    end

    def next_step
        @current_step = params[:current_step].to_i
        save_form_data_to_cache
        next_step_number = @current_step + 1

        if next_step_number > 8
            render plain: "No next step found", status: :not_found
            return
        end

        @next_step = "step_#{next_step_number}"

        if @calculator_config['calculator_steps'].key?(@next_step)
            @current_step = next_step_number
            update_cache(current_step: @current_step)
            set_questions
            set_active_locations
            render_step
        else
            render plain: "No next step found", status: :not_found
        end
    end

    def previous_step
        @current_step = params[:step].to_i
        @current_step -= 1
        @current_step = 1 if @current_step < 1
        update_cache(current_step: @current_step)
        set_questions
        set_active_locations
        render_step
    end

    def submit
        @current_step = 8
        cache_data = get_cache_data
        
        submission_params = params.permit(:first_name, :last_name, :company, :email, :phone, :terms_acceptance, :location_id)
        submission_params[:location_id] = cache_data["calculator_location_id"] if submission_params[:location_id].blank?
        
        @calculation = OfficeCalculation.new(submission_params.merge(steps_data: cache_data))

        if @calculation.save
            # Clear the cache after successful submission
            Rails.cache.delete(@cache_key)
            render :success
        else
            set_questions
            render :index
        end
    end

    private

    def load_calculator_config
        config_file = Rails.root.join('config', 'office_calculator_config.yml')
        @calculator_config = YAML.load_file(config_file)
    rescue => e
        @calculator_config = {}
    end

    def set_current_step
        @current_step = (params[:step].presence || params[:current_step].presence || session[:current_step].presence || 'start').to_s
        @current_step = @current_step.gsub('step_', '').to_i if @current_step != 'start'
        session[:current_step] = @current_step
    end

    def set_questions
        @questions = @calculator_config.dig('calculator_steps', "step_#{@current_step}")
        @questions ||= {}  # Set to an empty hash to avoid nil errors
    end

    def set_active_locations
        @active_locations ||= Location.all if @current_step == 1
    end

    def render_step
        begin
            render partial: "office_calculator/step_#{@current_step}", locals: { questions: @questions, current_step: @current_step }
        rescue ActionView::MissingTemplate
            render plain: "Error: Partial not found", status: :not_found
        rescue StandardError
            render plain: "An error occurred", status: :internal_server_error
        end
    end

    def save_form_data_to_cache
        current_step_config = @calculator_config['calculator_steps']["step_#{@current_step}"]
        
        Rails.logger.info "Saving data for step #{@current_step}: #{current_step_config.inspect}"
        Rails.logger.info "Received params for step #{@current_step}: #{params.inspect}"

        cache_data = Rails.cache.fetch(@cache_key) || {}

        current_step_config&.each do |field, data|
            if data['options'].is_a?(Hash)
                data['options'].each do |option_key, option_data|
                    cache_key = "calculator_#{@current_step}_#{field}_#{option_key}"
                    cache_value = params[cache_key]
                    cache_data[cache_key] = cache_value if cache_value.present?
                end
            else
                cache_key = "calculator_#{@current_step}_#{field}"
                cache_value = params[cache_key]
                cache_data[cache_key] = cache_value if cache_value.present?
            end
        end

        if params[:calculator_location_id].present?
            cache_data["calculator_location_id"] = params[:calculator_location_id]
        end

        Rails.cache.write(@cache_key, cache_data, expires_in: 1.hour)
        Rails.logger.info "Complete cache data after saving for step #{@current_step}: #{cache_data}"
    end

    def update_cache(data)
        cache_data = Rails.cache.fetch(@cache_key) || {}
        cache_data.merge!(data)
        Rails.cache.write(@cache_key, cache_data, expires_in: 1.hour)
    end

    def get_cache_data
        Rails.cache.fetch(@cache_key) || {}
    end

    def office_calculation_params
        params.permit(:first_name, :last_name, :company, :email, :phone, :terms_acceptance)
    end

    def load_questions_for_step(step)
        @calculator_config.dig('calculator_steps', "step_#{step}") || {}
    end

    def load_or_create_session
        session[:calculator_id] ||= SecureRandom.uuid
        @cache_key = "office_calculator_#{session[:calculator_id]}"
    end
end