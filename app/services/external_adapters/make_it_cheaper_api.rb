require 'uri'
require 'date'

module ExternalAdapters
  class MakeItCheaperApi
    class FetchError < StandardError; end
    class ValidationError < StandardError; end

    BASE_URI = ENV.fetch("LEAD_API_URI", "").freeze
    API_KEY = ENV.fetch("LEAD_API_ACCESS_TOKEN", "").freeze
    LEAD_API_PGUID = ENV.fetch("LEAD_API_PGUID", "").freeze
    LEAD_API_PACCNAME = ENV.fetch("LEAD_API_PACCNAME", "").freeze
    LEAD_API_PPARTNER = ENV.fetch("LEAD_API_PPARTNER", "").freeze

    def self.post(path, params = {})
      uri = URI("#{BASE_URI}/#{path}")
      defaults = {
        access_token: API_KEY,
        pGUID: LEAD_API_PGUID,
        pAccName: LEAD_API_PACCNAME,
        pPartner: LEAD_API_PPARTNER,
      }.merge!(params)

      response = HTTParty.post(
        uri.to_s,
        query: defaults
      )

      raise ValidationError, "Form input invalid" if response.code == 400
      raise FetchError, response.parsed_response["message"] unless response.success?

      response
    end
  end
end