require 'rails_helper'

RSpec.describe CallbackController, type: :controller do
  describe ".submit" do
    let(:valid_params) do
      {
        name: "Dave Newson",
        business_name: "Dave Newson LTD",
        telephone_number: "07654 321 123",
        email: "dave.newson@deavenewson.co.uk"
      }
    end

    let(:invalid_params) do
      {
        name: "Dave Newson",
        business_name: "Dave Newson LTD",
        telephone_number: "not_a_number",
        email: "dave.newson@deavenewson.co.uk"
      }
    end

    context "When the data is valid" do
      before do
        allow(ExternalAdapters::MakeItCheaperApi).to receive(:post).and_return("Success!!")
        post :submit, params: valid_params
      end

      it "redirects to root" do
        expect(controller).to redirect_to("/")
      end

      it "sets the flash to the success message" do
        expect(controller).to set_flash.to("Callback request received, we'll be in touch soon")
      end
    end

    context "When the data is invalid" do
      before do
        post :submit, params: invalid_params
      end

      it "renders the form" do
        expect(controller).to render_template(:new)
      end

      it "sets the flash to the invalid data message" do
        expect(controller).to set_flash.now.to("One or more field is invalid. Please check the form")
      end
    end

    context "When there is a problem with the API" do
      before do
        allow(ExternalAdapters::MakeItCheaperApi).to receive(:post).and_raise("Error")
        post :submit, params: valid_params
      end

      it "renders the form" do
        expect(controller).to render_template(:new)
      end

      it "sets the flash to the error message" do
        expect(controller).to set_flash.now.to("We're having some technical difficulties at the moment. Please try again in a few minutes")
      end
    end
  end
end
