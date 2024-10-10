OFFICE_CALCULATOR_CONFIG = YAML.load_file(Rails.root.join('config', 'office_calculator_config.yml'))

# Make the configuration accessible throughout the application
Rails.application.config.office_calculator = office_calculator_config

# Optionally, you can create a global constant for easier access
OFFICE_CALCULATOR_CONFIG = office_calculator_config.freeze