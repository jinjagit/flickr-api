Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get    '/photos',    to: 'static_pages#photos'
  root 'static_pages#home'
  resources :static_pagess
end
