Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'links#home'

  resources :links, only: [:new, :create, :show]

  get 'links/home'
  get ':shortened_link', to: 'links#shortened_link_redirect'
end
