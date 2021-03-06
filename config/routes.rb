require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:edit, :update]
  devise_scope :user do
    get 'users/sign_out(.:format)', to: 'devise/sessions#destroy'
  end

  mount RailsAdmin::Engine => '/admin_portal', as: 'rails_admin'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :storage_items, only: [:index, :edit, :update]
  resources :delivery_requests, :pickup_requests, only: [:show, :create, :new, :edit, :update, :destroy]
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
  patch 'admin/complete_packing_supplies_request/:id', to: 'admin_pages#complete_packing_supplies_request', as: 'complete_packing_supplies_request'
  patch 'admin/complete_pickup_request/:id', to: 'admin_pages#complete_pickup_request', as: 'complete_pickup_request'
  patch 'admin/complete_delivery_request/:id', to: 'admin_pages#complete_delivery_request', as: 'complete_delivery_request'
  get 'admin/sign_in_as_user', to: 'admin_pages#sign_in_as_user', as: 'admin_sign_in_as_user'
  post 'admin/sign_in_as_user' => 'admin_pages#post_sign_in_as_user'

  get '404', to: 'static_pages#not_found', as: 'not_found'
  get '422', to: 'static_pages#server_error'
  get '500', to: 'static_pages#server_error', as: 'server_error'

  get 'new-city' =>'static_pages#new-city'
  get 'national' =>'static_pages#national'
  get 'premium-on-demand-luxury-moving-storage' => 'static_pages#luxury'
  get 'moving-and-storage-on-demand' => 'static_pages#moving_and_storage'
  get 'storage-garage-organization' => 'static_pages#garage_organization'
  get 'cu-student-storage' => 'static_pages#cu_student_storage'
  get 'cheap-storage' => 'static_pages#cheap_storage'
  get 'storage-savings-colorado' => 'static_pages#landing_page_1'
  get 'cu-student-storage-2' => 'static_pages#landing_page_2'
  get 'moving-and-storage-on-demand-denver-boulder' => 'static_pages#landing_page_3'
  get 'premium-on-demand-luxury-moving-storage-2' => 'static_pages#landing_page_4'
  get 'storage-garage-organization-2' => 'static_pages#landing_page_5'
  get 'apartment' => 'static_pages#moving_and_storage'
  get 'student' => 'static_pages#cu_student_storage'


  get 'about', to: 'static_pages#about', as: 'about'
  get 'feedback', to: 'static_pages#feedback', as: 'feedback'
  get 'faq', to: 'static_pages#faq', as: 'faq'
  get 'contact' => 'static_pages#contact'
  get 'email' => 'static_pages#email_example'
  get 'terms-of-service', to: 'static_pages#terms_of_service', as: 'terms_of_service'
  get 'storage-service-tos', to: 'static_pages#storage_service_tos', as: 'storage_service_tos'
  get 'privacy-policy', to: 'static_pages#privacy_policy', as: 'privacy_policy'
  get 'users/referral', to: 'users#referral', as: 'users_referral'
  get 'how-quickbox-works', to: 'static_pages#how_quickbox_works', as: 'how_quickbox_works'
  get 'pricing', to: 'static_pages#pricing', as: 'pricing'
  get 'locations/boulder-colorado' => 'static_pages#boulder'
  get 'locations/denver-colorado' => 'static_pages#denver'

  get 'signup', to: 'signup_pages#select_items', as: 'new_signup_pages'
  post 'signup', to: 'signup_pages#post_select_items'
  post 'signup/create_login', to: 'signup_pages#create', as: 'signup_create_login'
  get 'signup/add_payment', to: 'signup_pages#show', as: 'signup_add_payment'
  patch 'signup/add_payment', to: 'signup_pages#add_payment'

  root 'static_pages#homepage'

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
