Rails.application.routes.draw do
  root 'version#show', defaults: { format: :json }
end
