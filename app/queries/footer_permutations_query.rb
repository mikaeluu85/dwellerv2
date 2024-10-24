# frozen_string_literal: true

# Fetches and caches permutations for prioritized locations to be displayed in the footer
class FooterPermutationsQuery
  class QueryError < StandardError; end

  CACHE_KEY = "footer_permutations"
  CACHE_EXPIRES_IN = 1.hour

  # @return [Hash<PremiseType, Array<Permutation>>] Hash of premise types and their permutations
  def self.fetch
    new.fetch
  end

  def fetch
    ActiveSupport::Notifications.instrument("footer_permutations.fetch") do |payload|
      result = Rails.cache.fetch(CACHE_KEY, expires_in: CACHE_EXPIRES_IN) do
        payload[:cache_hit] = false
        execute_query
      end
      payload[:cache_hit] = true
      result
    end
  end

  private

  def execute_query
    premise_types_with_permutations.each_with_object({}) do |premise_type, hash|
      hash[premise_type] = premise_type.permutations
                                     .joins(:location)
                                     .where(locations: { prioritized: true })
                                     .order("locations.name ASC")
    end
  end

  def premise_types_with_permutations
    PremiseType
      .joins(:permutations)
      .joins(:locations)
      .where(locations: { prioritized: true })
      .order(:name)
      .includes(permutations: :location)
      .distinct
  end

  #   def handle_error(error)
  #     error_context = {
  #       class: self.class.name,
  #       message: error.message,
  #       backtrace: error.backtrace&.first(5)
  #     }

  #     Rails.logger.error("FooterPermutationsQuery failed: #{error_context}")

  #     # Re-raise if in development/test environment
  #     raise error if Rails.env.development? || Rails.env.test?
  #   end
end
