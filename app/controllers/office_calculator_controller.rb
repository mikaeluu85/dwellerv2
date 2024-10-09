class OfficeCalculatorController < ApplicationController
    before_action :load_calculator_config
    before_action :set_current_step
    before_action :set_questions
    before_action :set_active_locations, only: [:index, :start, :next_step]

    def index
        session[:current_step] = 'start'
        @current_step = 'start'
    end

    def start
        session[:current_step] = 'step_1'
        @current_step = 'step_1'
        set_questions
        set_active_locations
        render_step
    end

    def next_step
        @current_step = params[:current_step]
        save_form_data_to_session
        next_step_number = @current_step.split('_').last.to_i + 1
        @next_step = "step_#{next_step_number}"

        if @calculator_config['calculator_steps'].key?(@next_step)
            @current_step = @next_step
            session[:current_step] = @current_step
            set_questions
            render_step
        else
            redirect_to office_calculator_result_path
        end
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
        @current_step = session[:current_step] || 'step_1'
    end

    def set_questions
        @questions = @calculator_config.dig('calculator_steps', @current_step)
        if @questions.nil?
            Rails.logger.error "No questions found for step: #{@current_step}"
            @questions = {}  # Set to an empty hash to avoid nil errors
        end
        Rails.logger.debug "Questions for step #{@current_step}: #{@questions.inspect}"
    end

    def set_active_locations
        @active_locations ||= Location.find_each.to_a if @current_step == 'step_1'
    end

    def render_step
        respond_to do |format|
            format.turbo_stream do
                render turbo_stream: turbo_stream.replace(
                    "calculator_content",
                    partial: @current_step,
                    locals: { questions: @questions, current_step: @current_step }
                )
            end
            format.html { render partial: @current_step, locals: { questions: @questions, current_step: @current_step } }
        end
    end

    def save_form_data_to_session
        current_step_config = @calculator_config['calculator_steps'][@current_step]
        current_step_config&.each do |field, data|
            if data['options'].is_a?(Hash)
                data['options'].each do |option_key, _|
                    session["calculator_#{field}_#{option_key}"] = params["#{field}_#{option_key}"]
                end
            else
                session["calculator_#{field}"] = params[field]
            end
        end
        
        # Add this line to save the selected location
        session["calculator_location_id"] = params[:location_id] if params[:location_id].present?
    end
end