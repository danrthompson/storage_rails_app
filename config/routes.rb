Rails.application.routes.draw do
  resources :users, only: [:edit, :update]
  devise_for :users

  devise_scope :user do
    get 'users/sign_out(.:format)', to: 'devise/sessions#destroy'
  end

  resources :storage_items, only: [:index, :edit, :update]
  resources :delivery_requests, :packing_supplies_requests, :pickup_requests, only: [:show, :create, :new, :edit, :update]

  get 'admin/block_time', to: 'admin_pages#block_time', as: 'admin_block_time'
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

  get '404', to: redirect('/404'), as: 'not_found'
  get '500', to: redirect('/500'), as: 'error'

  get 'about' => 'static_pages#about'
  get 'feedback' => 'static_pages#feedback'
  get 'faq' => 'static_pages#faq'
  get 'contact' => 'static_pages#contact'
  get 'email' => 'static_pages#email_example'



  get 'signup', to: 'signup_pages#new', as: 'new_signup_pages'
  post 'fast_signup', to: 'signup_pages#fast_signup', as: 'fast_signup'
  post 'signup', to: 'signup_pages#create', as: 'create_signup_pages'
  get 'signup/:id', to: 'signup_pages#show', as: 'confirm_signup_pages'
  patch 'signup/:id', to: 'signup_pages#add_payment', as: 'add_payment_signup_pages'

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
