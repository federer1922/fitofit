Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "routes#index"

  get '/create', to: 'routes#create'
  get '/show_month', to: 'routes#show_month_details'
  get '/show_day', to: 'routes#show_day_details'
  get '/destroy', to: 'routes#destroy'
end
