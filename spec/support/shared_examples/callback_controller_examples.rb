RSpec.shared_examples 'error_examples' do |message|
  it 'renders the form' do
    expect(controller).to render_template(:new)
  end

  it 'sets the flash to the error message' do
    expect(controller).to set_flash.now.to(message)
  end
end
