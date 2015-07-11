require 'resque/server'

Rails.application.routes.draw do
  get 'line_items/create'

  get 'line_items/destroy'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # mount the resque
  mount Resque::Server.new, at: '/resque'

  root 'static_pages#homepage'

  get 'sessions/new', as: :sign_in
  get 'sessions/destroy', as: :sign_out
  get 'sessions/authenticate'
  get 'sessions/fail'

  resources :brothers, only: [:index, :show] do
    member do
      get 'test_email'
    end
  end

  resources :meetings, only: [:index, :show, :create, :destroy] do
    member do
      post 'record/:brother_id/:status', action: 'record', as: 'record'
    end
  end

  resources :balances, only: [:update] do
  end

  resources :vouchers, only: [:index, :show, :new, :create, :edit, :update] do
    resources :line_items, only: [:destroy, :create]
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
