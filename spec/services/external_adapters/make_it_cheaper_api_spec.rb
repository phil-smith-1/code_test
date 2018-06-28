require "rails_helper"

RSpec.describe ExternalAdapters::MakeItCheaperApi, :vcr do
  describe '.post' do
    it "returns success if the customer data is correct" do
      response = described_class.post("api/v1/create", params)
      expect(response.message).to eq("Enqueue success")
      expect(response.errors).to eq([])
    end

    it "returns an error if the request data is invalid" do
      expect {
        described_class.post("api/v1/create")
      }.to raise_error(ExternalAdapters::MakeItCheaperApi::ValidationError)
    end

    it "returns an error if the request url doesn't exist" do
      expect {
        described_class.post("wrong-path", params)
      }.to raise_error(ExternalAdapters::MakeItCheaperApi::FetchError)
    end
  end
end