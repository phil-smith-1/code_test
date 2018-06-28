require "rails_helper"

RSpec.describe ExternalAdapters::MakeItCheaperApi, :vcr do
  let(:name) { "Dave Newson" }
  let(:business_name) { "Dave Newson LTD" }
  let(:phone) { "07654 321 123" }
  let(:email) { "dave.newson@deavenewson.co.uk" }
  let(:params) do
    {
      name: name,
      business_name: business_name,
      telephone_number: phone,
      email: email
    }
  end

  describe '.post' do
    it "returns success if the customer data is correct" do
      VCR.use_cassette("success") do
        response = described_class.post("api/v1/create", params)
        expect(response.parsed_response["message"]).to eq("Enqueue success")
        expect(response.parsed_response["errors"]).to eq([])
      end
    end

    it "returns an error if the request data is invalid" do
      VCR.use_cassette("validation_error") do
        expect {
          described_class.post("api/v1/create")
        }.to raise_error(ExternalAdapters::MakeItCheaperApi::ValidationError)
      end
    end

    it "returns an error if the request url doesn't exist" do
      VCR.use_cassette("bad_request") do
        expect {
          described_class.post("wrong-path", params)
        }.to raise_error(ExternalAdapters::MakeItCheaperApi::FetchError)
      end
    end
  end
end