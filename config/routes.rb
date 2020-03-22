Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'static_pages#home'

  resources :links, only: [:new, :create, :show]
  
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :links, only: [:create]
    end
  end

  get ':shortened_link',
      to: 'api/v1/links#shortened_link_redirect', 
      constraints: lambda { |req| req.format == :json }
  
  get ':shortened_link', 
      to: 'links#shortened_link_redirect',
      constraints: lambda { |req| req.format == :html }
end
