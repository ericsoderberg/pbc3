Pbc3::Application.routes.draw do
  
  resources :contacts

  resources :events

  resources :groups

  resources :videos

  resources :photos

  resources :notes
  
  # http://blog.grow20.com/fun-with-ssl-for-accounts-only
  class SSL
    def self.matches?(request)
      # This way you don't need SSL for your development server
      return true unless Rails.env.production?
      request.port == 3002
    end
  end

  constraints SSL do
    devise_for :users
  end
  
  # Redirect to SSL from non-SSL so you don't get 404s
  # Repeat for any custom Devise routes
  match "/users(/*path)", :to => redirect { |_, request|
    "https://" + request.host + ":3002" + request.fullpath }

  get "home/index"

  root :to => "home#index"
  
  resources :pages
  
  match '/:id', :to => "pages#show", :as => 'friendly_page'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
