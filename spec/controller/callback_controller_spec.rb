require 'rails_helper'

RSpec.describe CallbackController, type: :controller do
  describe '.submit' do
    let(:valid_params) do
      {
        name: 'Dave Newson',
        business_name: 'Dave Newson LTD',
        telephone_number: '07654 321 123',
        email: 'dave.newson@deavenewson.co.uk'
      }
    end

    let(:invalid_name) { { name: (0..100).map { 'A' }.join } }
    let(:invalid_business_name) { { business_name: (0..100).map { 'A' }.join } }
    let(:invalid_telephone_number) { { telephone_number: 'not_a_number' } }
    let(:invalid_email) { { email: 'not_a_valid_email_address' } }

    context 'When the data is valid' do
      before do
        allow(ExternalAdapters::MakeItCheaperApi).to receive(:post).and_return('Success!!')
        post :submit, params: valid_params
      end

      it 'redirects to root' do
        expect(controller).to redirect_to('/')
      end

      it 'sets the flash to the success message' do
        expect(controller).to set_flash.to('Callback request received, we\'ll be in touch soon')
      end
    end

    context 'When the name is invalid' do
      before do
        post :submit, params: valid_params.merge(invalid_name)
      end

      include_examples('error_examples', 'One or more field is invalid. Please check the form')
    end

    context 'When the business name is invalid' do
      before do
        post :submit, params: valid_params.merge(invalid_business_name)
      end

      include_examples('error_examples', 'One or more field is invalid. Please check the form')
    end

    context 'When the telephone number is invalid' do
      before do
        post :submit, params: valid_params.merge(invalid_telephone_number)
      end

      include_examples('error_examples', 'One or more field is invalid. Please check the form')
    end

    context 'When the email is invalid' do
      before do
        post :submit, params: valid_params.merge(invalid_email)
      end

      include_examples('error_examples', 'One or more field is invalid. Please check the form')
    end

    context 'When there is a problem with the API' do
      before do
        allow(ExternalAdapters::MakeItCheaperApi).to receive(:post).and_raise('Error')
        post :submit, params: valid_params
      end

      include_examples('error_examples', 'We\'re having some technical difficulties at the moment. Please try again in a few minutes')
    end
  end
end
