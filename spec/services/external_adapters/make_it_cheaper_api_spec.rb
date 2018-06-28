require 'rails_helper'

RSpec.describe ExternalAdapters::MakeItCheaperApi, :vcr do
  let(:params) do
    {
      name: 'Dave Newson',
      business_name: 'Dave Newson LTD',
      telephone_number: '07654 321 123',
      email: 'dave.newson@deavenewson.co.uk'
    }
  end

  describe '.post' do
    it 'returns success if the customer data is correct' do
      VCR.use_cassette('success') do
        response = described_class.post('api/v1/create', params)
        expect(response.parsed_response['message']).to eq('Enqueue success')
        expect(response.parsed_response['errors']).to eq([])
      end
    end

    it 'returns an error if the request data is invalid' do
      VCR.use_cassette('validation_error') do
        expect { described_class.post('api/v1/create') }.to raise_error(ExternalAdapters::MakeItCheaperApi::ValidationError)
      end
    end

    it 'returns an error if the request url doesn\'t exist' do
      VCR.use_cassette('bad_request') do
        expect { described_class.post('wrong-path', params) }.to raise_error(ExternalAdapters::MakeItCheaperApi::FetchError)
      end
    end
  end
end
