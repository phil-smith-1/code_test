class CallbackController < ApplicationController
  def new
    @params_to_send = {}
  end

  def submit
    @params_to_send = {
      name:             params[:name],
      business_name:    params[:business_name],
      telephone_number: params[:telephone_number],
      email:            params[:email]
    }

    if !valid_params?
      flash.now.alert = "One or more field is invalid. Please check the form"
      return render :new
    end

    ExternalAdapters::MakeItCheaperApi.post("api/v1/create", @params_to_send)
    redirect_to "/", notice: "Callback request received, we'll be in touch soon"
  rescue Exception => e
    flash.now.alert = "An error has occurred: #{e.message}"
    render :new
  end

  private

  def valid_params?
    @params_to_send.all? { |k, _v| send("valid_#{k}?") }
  end

  def valid_name?
    @params_to_send[:name].length <= 100
  end

  def valid_business_name?
    @params_to_send[:business_name].length <= 100
  end

  def valid_telephone_number?
    @params_to_send[:telephone_number].length <= 13  && /[\D&&\S]/.match(@params_to_send[:telephone_number]).nil?
  end

  def valid_email?
    @params_to_send[:email].length <= 80 && @params_to_send[:email].include?("@")
  end
end
