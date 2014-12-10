require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:edit, :update]

  devise_scope :user do
    get 'users/sign_out(.:format)', to: 'devise/sessions#destroy'
  end

  resources :storage_items, only: [:index, :edit, :update]
  resources :delivery_requests, :packing_supplies_requests, :pickup_requests, only: [:show, :create, :new, :edit, :update, :destroy]
  resources :subscribers, only: [:create]

  get 'admin/block_time', to: 'admin_pages#block_time', as: 'block_time'
  post 'admin/block_time', to: 'admin_pages#create_block_time'
  get 'admin', to: 'admin_pages#admin', as: 'admin'
  get 'admin/record_pickup_request/:id', to: 'admin_pages#record_pickup_request', as: 'admin_record_pickup_request'
  get 'admin/record_delivery_request/:id', to: 'admin_pages#record_delivery_request', as: 'admin_record_delivery_request'
  patch 'admin/record_pickup_request/:id', to: 'admin_pages#save_changes_pickup_request'
  patch 'admin/record_delivery_request/:id', to: 'admin_pages#save_changes_delivery_request'

  get 'admin/assign_driver/:id', to: 'admin_pages#assign_driver', as: 'admin_assign_driver'





  post 'admin/assign_driver/:id', to: 'admin_pages#update_assign_driver'
  get 'users/referral', to: 'users#referral', as: 'users_referral'

  patch 'admin/complete_packing_supplies_request/:id', to: 'admin_pages#complete_packing_supplies_request', as: 'complete_packing_supplies_request'
  patch 'admin/complete_pickup_request/:id', to: 'admin_pages#complete_pickup_request', as: 'complete_pickup_request'
  patch 'admin/complete_delivery_request/:id', to: 'admin_pages#complete_delivery_request', as: 'complete_delivery_request'

  get '404', to: 'static_pages#not_found', as: 'not_found'
  get '422', to: 'static_pages#server_error'
  get '500', to: 'static_pages#server_error', as: 'server_error'

  get 'new-city' =>'static_pages#new-city'
  get 'national' =>'static_pages#national'
  get 'apartment' =>'static_pages#apartment'
  get 'garage' =>'static_pages#garage' #housewives
  get 'college' => 'static_pages#college'
  get 'moving' => 'static_pages#moving'
  get 'luxury' => 'static_pages#luxury'

  get 'about' => 'static_pages#about'
  get 'feedback' => 'static_pages#feedback'
  get 'faq' => 'static_pages#faq'
  get 'contact' => 'static_pages#contact'
  get 'email' => 'static_pages#email_example'
  get 'tires' => 'static_pages#tires'
  # get 'althome' => 'static_pages#althome'
  # get 'signup_option' => 'static_pages#'


  get 'signup', to: 'signup_pages#new', as: 'new_signup_pages'
  # post 'fast_signup', to: 'signup_pages#fast_signup', as: 'fast_signup'
  post 'signup', to: 'signup_pages#create', as: 'create_signup_pages'
  get 'signup/items/:id', to: 'signup_pages#select_items', as: 'signup_select_items'
  post 'signup/items/:id', to: 'signup_pages#post_select_items'
  patch 'signup/:id', to: 'signup_pages#add_payment', as: 'add_payment_signup_pages'

  root 'static_pages#homepage'

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

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
