#Validations
#Thank you
#GUI

class OfficeCalculatorController < ApplicationController
    before_action :load_calculator_config
    before_action :set_current_step, only: [:index, :start, :next_step, :previous_step]
    before_action :load_or_create_session, except: [:index]
    before_action :initialize_cached_data

    def index
        @current_step = params[:step] || 'start'
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
        @current_step = 1 if @current_step < 1
        update_cache(current_step: @current_step)
        set_questions
        set_active_locations
        render_step
    end

    def submit
        @current_step = 8
        cache_data = get_cache_data

        submission_params = params.permit(:authenticity_token, :commit, :contact_form_first_name, :contact_form_last_name, :contact_form_company, :contact_form_email, :contact_form_phone, :contact_form_terms_acceptance, :location_id).transform_values do |value|
          value.is_a?(String) ? ActionController::Base.helpers.sanitize(value) : value
        end
        submission_params[:location_id] = cache_data["calculator_location_id"] if submission_params[:location_id].blank?

        # Structure the cache_data before assigning to steps_data
        structured_steps_data = OfficeCalculation.structure_steps_data(cache_data)

        @calculation = OfficeCalculation.new(
          first_name: submission_params[:contact_form_first_name],
          last_name: submission_params[:contact_form_last_name],
          company: submission_params[:contact_form_company],
          email: submission_params[:contact_form_email],
          phone: submission_params[:contact_form_phone],
          terms_acceptance: submission_params[:contact_form_terms_acceptance],
          location_id: submission_params[:location_id],
          steps_data: structured_steps_data
        )

        if @calculation.save
            Rails.cache.delete(@cache_key)
            render partial: 'success', locals: { calculation: @calculation }
        else
            Rails.logger.error "Validation failed: #{@calculation.errors.full_messages.join(', ')}"
            set_questions
            render :index
        end
    rescue StandardError => e
        Rails.logger.error "Failed to save office calculation: #{e.message}"
        redirect_to office_calculator_path, alert: 'There was an error saving your data.'
    end

    private

    def load_calculator_config
        config_file = Rails.root.join('config', 'office_calculator_config.yml')
        @calculator_config = YAML.load_file(config_file)
    rescue => e
        Rails.logger.error "Failed to load calculator config: #{e.message}"
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
        cached_data = get_cache_data
        render partial: "office_calculator/step_#{@current_step}", 
               locals: { 
                 questions: @questions, 
                 current_step: @current_step, 
                 cached_data: cached_data 
               }
    end

    def save_form_data_to_cache
        current_step_config = @calculator_config['calculator_steps']["step_#{@current_step}"]

        Rails.logger.info "Saving data for step #{@current_step}: #{current_step_config.inspect}"
        Rails.logger.info "Received params for step #{@current_step}: #{params.inspect}"

        cache_data = Rails.cache.fetch(@cache_key) || {}

        current_step_config&.each do |field, data|
            if data['options'].is_a?(Hash)
                data['options'].each do |option_key, option_data|
                    cache_key_field = "calculator_#{@current_step}_#{field}_#{option_key}"
                    cache_value = sanitize_value(params[cache_key_field])
                    cache_data[cache_key_field] = cache_value if cache_value.present?
                end
            else
                cache_key_field = "calculator_#{@current_step}_#{field}"
                cache_value = sanitize_value(params[cache_key_field])
                cache_data[cache_key_field] = cache_value if cache_value.present?
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

    def load_or_create_session
        session[:calculator_id] ||= SecureRandom.uuid
        @cache_key = "office_calculator_#{session[:calculator_id]}"
    end

    def initialize_cached_data
        @cached_data = session[:calculator_data] || {}
    end

    private

    def sanitize_value(value)
        case value
        when String
            ActionController::Base.helpers.sanitize(value)
        when Array
            value.map { |v| sanitize_value(v) }
        when Hash
            value.transform_values { |v| sanitize_value(v) }
        else
            value
        end
    end
end