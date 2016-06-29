Rails.application.routes.draw do
  root 'version#show'

  get 'version/show'
end
