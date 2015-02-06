Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root "properties#index"

  resources :properties do
    post "interested", on: :member
  end

  # resources :agents

  get "/contact_us" => "contacts#new"
  post "/contact_us" => "contacts#create"
end
