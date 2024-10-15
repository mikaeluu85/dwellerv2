#Validations
#Thank you
#GUI
# Add limiter on fetch reports

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

        structured_steps_data = OfficeCalculation.structure_steps_data(cache_data)

        @office_calculation = OfficeCalculation.new(
          first_name: submission_params[:contact_form_first_name],
          last_name: submission_params[:contact_form_last_name],
          company: submission_params[:contact_form_company],
          email: submission_params[:contact_form_email],
          phone: submission_params[:contact_form_phone],
          terms_acceptance: submission_params[:contact_form_terms_acceptance],
          location_id: submission_params[:location_id],
          steps_data: structured_steps_data,
          uuid: SecureRandom.uuid
        )

        if @office_calculation.save
            Rails.cache.delete(@cache_key)
            render turbo_stream: turbo_stream.replace("calculator_content", partial: 'success', locals: { office_calculation: @office_calculation })
        else
            Rails.logger.error "Validation failed: #{@office_calculation.errors.full_messages.join(', ')}"
            set_questions
            render :index, status: :unprocessable_entity
        end
    rescue StandardError => e
        Rails.logger.error "Failed to save office calculation: #{e.message}"
        redirect_to office_calculator_path, alert: 'There was an error saving your data.'
    end

    def result
        @office_calculation = OfficeCalculation.find_by(uuid: params[:uuid], email: params[:email])
        
        if @office_calculation
            @location = @office_calculation.location
            @steps_data = @office_calculation.steps_data
            @step_1_data = @steps_data['1'] || {}
            
            # Perform calculations
            @total_area = calculate_total_area(@steps_data)
            @bashyra_range = calculate_bashyra_range(@total_area, @location)
            
            # New calculations
            @electricity_range = calculate_electricity_range(@total_area)
            @heat_cooling_range = calculate_heat_cooling_range(@bashyra_range)
            @recurring_addons = calculate_recurring_addons(@total_area, @steps_data)
            @one_off_costs = calculate_one_off_costs(@steps_data)

            Rails.logger.debug "Calculator Config: #{@calculator_config.inspect}"
            Rails.logger.debug "One-off Costs: #{@one_off_costs.inspect}"

            @map_hash = GoogleMapsService.generate_map(@location)
        else
            redirect_to office_calculator_path, alert: 'Beräkningen kunde inte hittas eller e-postadressen matchar inte.'
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

    def office_calculation_params
        params.require(:office_calculation).permit(:first_name, :email)
    end

    def calculate_total_area(steps_data)
        base_total_area = 0
        
        office_space_preference = steps_data.dig('1', 'office_space_preference')
        Rails.logger.debug "Office Space Preference: #{office_space_preference}"
        
        if office_space_preference.present?
            office_space_preference_multiplier = get_office_space_preference_multiplier(office_space_preference)
        else
            Rails.logger.error "Missing 'office_space_preference' in steps_data['1']"
            office_space_preference_multiplier = 1.0
        end

        Rails.logger.debug "Steps Data: #{steps_data.inspect}"

        @calculator_config['calculator_steps'].each do |step, step_data|
            Rails.logger.debug "Processing step: #{step}"
            next if step == 'step_1' || step == 'step_8'  # Skip steps without room sizes

            step_key = step.gsub('step_', '')

            step_data.each do |field, field_data|
                Rails.logger.debug "Processing field: #{field}"

                if field_data.is_a?(Hash) && field_data['room_size']
                    # Handle direct fields like open_plan_workspaces
                    if steps_data[step_key] && steps_data[step_key][field]
                        count = steps_data[step_key][field].to_i
                        area = field_data['room_size'] * count
                        base_total_area += area
                        Rails.logger.debug "Added area for #{field}: #{area} (#{field_data['room_size']} * #{count})"
                    end
                elsif field_data.is_a?(Hash) && field_data['options'].is_a?(Hash)
                    # Handle nested options like in private_offices
                    field_data['options'].each do |option, option_data|
                        if option_data['room_size'] && steps_data[step_key] && steps_data[step_key]["#{field}_#{option}"]
                            count = steps_data[step_key]["#{field}_#{option}"].to_i
                            area = option_data['room_size'] * count
                            base_total_area += area
                            Rails.logger.debug "Added area for #{field}_#{option}: #{area} (#{option_data['room_size']} * #{count})"
                        end
                    end
                end
            end
        end

        Rails.logger.debug "Final Base Total Area: #{base_total_area}"
        Rails.logger.debug "Office Space Preference Multiplier: #{office_space_preference_multiplier}"

        adjusted_area = base_total_area * office_space_preference_multiplier
        min_area = (adjusted_area * 0.9).round
        max_area = (adjusted_area * 1.1).round

        Rails.logger.debug "Adjusted Area: #{adjusted_area}"
        Rails.logger.debug "Min Area: #{min_area}, Max Area: #{max_area}"

        { min: min_area, max: max_area }
    end

    def get_office_space_preference_multiplier(preference)
        case preference
        when "Mindre yta än normal (10-13kvm)"
            0.9
        when "Normal mängd yta (13-20kvm)"
            1.0
        when "Extra mängd yta (20kvm+)"
            1.15
        else
            1.0  # Default to normal if preference is not recognized
        end
    end

    def calculate_bashyra_range(total_area, location)
        return { min: 0, max: 0 } unless location&.bashyra

        min_bashyra = (total_area[:min] * location.bashyra / 12).round
        max_bashyra = (total_area[:max] * location.bashyra / 12).round

        { min: min_bashyra, max: max_bashyra }
    end

    def calculate_electricity_range(total_area)
        electricity_sqm_price = @calculator_config['constants']['electricity_sqm_price']
        
        min_electricity = (total_area[:min] * electricity_sqm_price / 12).round
        max_electricity = (total_area[:max] * electricity_sqm_price / 12).round

        { min: min_electricity, max: max_electricity }
    end

    def calculate_heat_cooling_range(bashyra_range)
        va_tax_sqm_price = @calculator_config['constants']['va_tax_sqm_price']
        
        min_heat_cooling = (bashyra_range[:min] * va_tax_sqm_price).round
        max_heat_cooling = (bashyra_range[:max] * va_tax_sqm_price).round

        { min: min_heat_cooling, max: max_heat_cooling }
    end

    def calculate_recurring_addons(total_area, steps_data)
      addon_config = @calculator_config['calculator_steps']['step_7']['additional_services']['options']
      current_employees = steps_data['1']['current_employees'].to_i

      addons = {
        office_insurance: { min: 0, max: 0 },
        waste_management: { min: 0, max: 0 },
        premises_alarm: { min: 0, max: 0 },
        printer: { min: 0, max: 0 },
        cleaning: { min: 0, max: 0 },
        internet_connection: { min: 0, max: 0 },
        coffee_machine_rental: { min: 0, max: 0 }
      }

      total_min = 0
      total_max = 0

      steps_data['7']&.each do |key, value|
        next unless value == '1' # Check if the addon is selected

        case key
        when 'additional_services_office_insurance'
          min = (total_area[:min] * addon_config['office_insurance']['per_sqm_cost']).round
          max = (total_area[:max] * addon_config['office_insurance']['per_sqm_cost']).round
          addons[:office_insurance] = { min: min, max: max }
        when 'additional_services_waste_management'
          cost = current_employees * addon_config['waste_management']['per_person_cost'] * 12
          addons[:waste_management] = { min: cost, max: cost }
        when 'additional_services_premises_alarm'
          cost = addon_config['premises_alarm']['per_month_cost'] * 12
          addons[:premises_alarm] = { min: cost, max: cost }
        when 'additional_services_printer'
          cost = addon_config['printer']['per_month_cost'] * 12
          addons[:printer] = { min: cost, max: cost }
        when 'additional_services_cleaning'
          cost = current_employees * addon_config['cleaning']['per_person_cost'] * 12
          addons[:cleaning] = { min: cost, max: cost }
        when 'additional_services_internet_connection'
          cost = addon_config['internet_connection']['per_month_cost'] * 12
          addons[:internet_connection] = { min: cost, max: cost }
        when 'additional_services_coffee_machine_rental'
          cost = addon_config['coffee_machine_rental']['per_month_cost'] * 12
          addons[:coffee_machine_rental] = { min: cost, max: cost }
        end
      end

      addons.each_value do |value|
        total_min += value[:min]
        total_max += value[:max]
      end

      {
        addons: addons,
        total: { min: (total_min / 12.0).round, max: (total_max / 12.0).round }
      }
    end

    def calculate_one_off_costs(steps_data)
      addon_config = @calculator_config['calculator_steps']['step_7']['additional_services']['options']
      current_employees = steps_data['1']['current_employees'].to_i

      one_off_costs = {
        desks: { cost: 0, count: 0 },
        work_chairs: { cost: 0, count: 0 }
      }

      total_cost = 0

      steps_data['7']&.each do |key, value|
        next unless value == '1' # Check if the addon is selected

        case key
        when 'additional_services_desks'
          count = current_employees
          cost = addon_config['desks']['one_off_cost'] * count
          one_off_costs[:desks] = { cost: cost, count: count }
          total_cost += cost
        when 'additional_services_work_chairs'
          count = current_employees
          cost = addon_config['work_chairs']['one_off_cost'] * count
          one_off_costs[:work_chairs] = { cost: cost, count: count }
          total_cost += cost
        end
      end

      {
        costs: one_off_costs,
        total: total_cost,
        monthly: (total_cost / 36.0).round
      }
    end

    # ... other calculation methods ...
end