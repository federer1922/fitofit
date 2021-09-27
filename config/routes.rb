Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "routes#index"

  get '/create', to: 'routes#create' #post
  get '/show_month', to: 'routes#show_month_details'
  get '/show_day', to: 'routes#show_day_details'
  delete '/destroy', to: 'routes#destroy'
  get '/edit_month', to: 'routes#edit_month'
  get '/update_month', to: 'routes#update_month'
  get '/edit_day', to: 'routes#edit_day'
  get '/update_day', to: 'routes#update_day' #put
end
