Rails.application.routes.draw do
  resources :users, only: [:edit, :update]
  devise_for :users, except: [:edit, :update]
  resources :storage_items
  resources :delivery_requests, :pickup_requests, only: [:show, :create]
  resources :box_requests, only: [:show, :create, :new]

  get 'delivery_requests/new/:ids', to: 'delivery_requests#new', as: 'new_delivery_request'
  get 'pickup_requests/new/:num_boxes', to: 'pickup_requests#new', as: 'new_pickup_request'

  get 'admin_page' => 'admin_pages#admin_page'
  post 'admin_pages/complete_request/:id', to: 'admin_pages#complete_request', as: 'complete_request'

  get '404', to: redirect('/404'), as: 'not_found'
  get '500', to: redirect('/500'), as: 'error'

  get 'about' => 'static_pages#extra-about'
  get 'feedback' => 'static_pages#extra-feedback'
  get 'faq' => 'static_pages#extra-faq'
  get 'contact' => 'static_pages#extra-contact'

  get 'signup', to: 'signup_pages#new', as: 'new_signup_pages'
  post 'signup', to: 'signup_pages#create', as: 'create_signup_pages'
  get 'signup/:id', to: 'signup_pages#show', as: 'confirm_signup_pages'
  post 'signup/:id', to: 'signup_pages#add_payment', as: 'add_payment_signup_pages'

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
