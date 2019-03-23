Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get    '/info',    to: 'static_pages#info'
  get    '/photos',  to: 'static_pages#photos'
  get    '/albums',  to: 'static_pages#albums'
  get    '/album',  to: 'static_pages#album'
  root 'static_pages#home'
  resources :static_pagess
end
