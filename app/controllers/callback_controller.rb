class CallbackController < ApplicationController
  def new
    @params_to_send = {}
  end

  def submit
    @params_to_send = sanitize_params(params)

    return submit_error('One or more field is invalid. Please check the form') unless valid_params?

    ExternalAdapters::MakeItCheaperApi.post('api/v1/create', @params_to_send)
    redirect_to '/', notice: 'Callback request received, we\'ll be in touch soon'
  rescue StandardError => e
    Rails.logger.error(e)
    submit_error('We\'re having some technical difficulties at the moment. Please try again in a few minutes')
  end

  private

  def submit_error(message)
    flash.now.alert = message
    render :new
  end

  def sanitize_params(params)
    {
      name:             params[:name],
      business_name:    params[:business_name],
      telephone_number: params[:telephone_number],
      email:            params[:email]
    }
  end

  def valid_params?
    @params_to_send.all? { |k, _v| send("valid_#{k}?") }
  end

  def valid_name?
    !@params_to_send[:name].blank? &&
      @params_to_send[:name].length <= 100
  end

  def valid_business_name?
    !@params_to_send[:business_name].blank? &&
      @params_to_send[:business_name].length <= 100
  end

  def valid_telephone_number?
    !@params_to_send[:telephone_number].blank? &&
      @params_to_send[:telephone_number].length <= 13 &&
      /[\D&&\S]/.match(@params_to_send[:telephone_number]).nil?
  end

  def valid_email?
    !@params_to_send[:email].blank? &&
      @params_to_send[:email].length <= 80 &&
      @params_to_send[:email].include?('@')
  end
end
