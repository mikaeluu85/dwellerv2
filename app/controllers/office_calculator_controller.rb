class OfficeCalculatorController < ApplicationController
    before_action :load_calculator_config

    def index
        @current_step = session[:current_step] || 'step_1'
        @questions = @current_step == 'start' ? nil : @calculator_config['calculator_steps'][@current_step]
        
        # Add this line to fetch active locations for step 1
        @active_locations = Location.all if @current_step == 'step_1'
    end

    def start
        session[:current_step] = 'step_1'
        @current_step = 'step_1'
        @questions = @calculator_config['calculator_steps'][@current_step]

        respond_to do |format|
            format.turbo_stream do
                render turbo_stream: turbo_stream.replace(
                    "calculator_content",
                    partial: @current_step,
                    locals: { questions: @questions, current_step: @current_step, active_locations: @active_locations }
                )
            end
        end
    end

    def next_step
        @current_step = params[:current_step].presence || 'step_1'
        next_step_number = @current_step.split('_').last.to_i + 1
        @next_step = "step_#{next_step_number}"

        # Save form data to session
        save_form_data_to_session

        if @calculator_config['calculator_steps'].key?(@next_step)
            @current_step = @next_step
            @questions = @calculator_config['calculator_steps'][@current_step]
        
            respond_to do |format|
                format.turbo_stream do
                    render turbo_stream: turbo_stream.replace(
                        "calculator_content",
                        partial: @current_step,
                        locals: { questions: @questions, current_step: @current_step, active_locations: @active_locations }
                    )
                end
            end
        else
            # Handle completion of all steps
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

    def save_form_data_to_session
        current_step_config = @calculator_config['calculator_steps'][@current_step]
        current_step_config.each do |field, data|
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