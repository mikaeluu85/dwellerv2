class OfficeCalculatorController < ApplicationController
    before_action :load_calculator_config
    before_action :set_current_step, only: [:index, :start, :next_step, :previous_step]

    def index
        session[:current_step] = 'start'
        @current_step = 'start'
    end

    def start
        session[:current_step] = 'step_1'
        @current_step = 1
        set_questions
        set_active_locations
        render_step
    end

    def next_step
        @current_step = params[:current_step].to_s.gsub('step_', '').to_i
        save_form_data_to_session
        next_step_number = @current_step + 1

        if next_step_number > 8
            render plain: "No next step found", status: :not_found
            return
        end

        @next_step = "step_#{next_step_number}"

        if @calculator_config['calculator_steps'].key?(@next_step)
            @current_step = next_step_number
            session[:current_step] = "step_#{@current_step}"
            set_questions
            set_active_locations
            render_step
        else
            render plain: "No next step found", status: :not_found
        end
    end

    def previous_step
        @current_step = params[:step].to_s.gsub('step_', '').to_i
        @current_step -= 1
        @current_step = 1 if @current_step < 1
        session[:current_step] = "step_#{@current_step}"
        set_questions
        set_active_locations
        render_step
    end

    private

    def load_calculator_config
        config_file = Rails.root.join('config', 'office_calculator_config.yml')
        @calculator_config = YAML.load_file(config_file)
    rescue => e
        @calculator_config = {}
    end

    def set_current_step
        @current_step = (params[:step].presence || params[:current_step].presence || 'step_1').to_s.gsub('step_', '').to_i
        @current_step = 1 if @current_step < 1
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

    def save_form_data_to_session
        current_step_config = @calculator_config['calculator_steps'][@current_step]
        current_step_config&.each do |field, data|
            if data['input_type'] == 'checkbox'
                data['options'].each do |option_key, _|
                    session["calculator_#{field}_#{option_key}"] = params["#{field}_#{option_key}"] == '1'
                end
            elsif data['options'].is_a?(Hash)
                data['options'].each do |option_key, _|
                    session["calculator_#{field}_#{option_key}"] = params["#{field}_#{option_key}"]
                end
            else
                session["calculator_#{field}"] = params[field]
            end
        end

        # Save the selected location if present
        session["calculator_location_id"] = params[:location_id] if params[:location_id].present?
    end
end