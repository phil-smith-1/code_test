Rails.application.routes.draw do
  root 'callback#new'
  post 'callback/submit'
end
