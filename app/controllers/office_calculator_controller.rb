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
        save_form_data_to_session  # Ensure this is called to save data to the session
        next_step_number = @current_step + 1

        Rails.logger.info "Session data after saving for step #{@current_step}: #{session.to_hash.select { |key, _| key.start_with?('calculator_') }}"

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

    def submit
        steps_data = {}
        (1..7).each do |step|
            step_data = {}
            @calculator_config['calculator_steps']["step_#{step}"].each do |field, _|
                session_key = "calculator_#{step}_#{field}"
                step_data[field] = session[session_key] if session[session_key].present?
            end
            steps_data["step_#{step}"] = step_data unless step_data.empty?
        end

        Rails.logger.info "Session data before submission: #{session.to_hash.select { |key, _| key.start_with?('calculator_') }}"
        Rails.logger.info "Steps data being submitted: #{steps_data}"

        @office_calculation = OfficeCalculation.new(office_calculation_params)
        @office_calculation.steps_data = steps_data
        @office_calculation.location_id = session["calculator_location_id"] if @office_calculation.location_id.blank?

        if @office_calculation.save
            session.keys.each { |key| session.delete(key) if key.to_s.start_with?('calculator_') }
            redirect_to office_calculator_thank_you_path, notice: 'Your calculation has been submitted successfully!'
        else
            flash[:alert] = 'There was an error submitting your calculation. Please try again.'
            @current_step = 8
            @questions = load_questions_for_step(@current_step)
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

    def save_form_data_to_session
        current_step_config = @calculator_config['calculator_steps']["step_#{@current_step}"]
        
        Rails.logger.info "Saving data for step #{@current_step}: #{current_step_config.inspect}"
        Rails.logger.info "Received params for step #{@current_step}: #{params.inspect}"

        current_step_config&.each do |field, data|
            session_key = "calculator_#{@current_step}_#{field}"
            session_value = params[session_key]
            session[session_key] = session_value if session_value.present?
            Rails.logger.info "Saved #{session_key}: #{session_value}"
        end

        # Save the selected location if present
        if params[:calculator_location_id].present?
            session["calculator_location_id"] = params[:calculator_location_id]
            Rails.logger.info "Saved calculator_location_id: #{params[:calculator_location_id]}"
        end

        Rails.logger.info "Complete session data after saving for step #{@current_step}: #{session.to_hash.select { |key, _| key.start_with?('calculator_') }}"
    end

    def office_calculation_params
        params.permit(:first_name, :last_name, :company, :email, :phone, :terms_acceptance)
    end

    def load_questions_for_step(step)
        @calculator_config.dig('calculator_steps', "step_#{step}") || {}
    end
end