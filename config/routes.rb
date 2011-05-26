Pbc3::Application.routes.draw do

  # http://blog.grow20.com/fun-with-ssl-for-accounts-only
  class SSL
    def self.matches?(request)
      # This way you don't need SSL for your development server
      #return true unless Rails.env.production?
      request.ssl?
    end
  end

  constraints SSL do
    resources :accounts do
      member do
        get 'fills', :controller => 'filled_forms',
          :action => 'user_index'
      end
    end
    devise_for :users
    resource :site, :except => [:show, :destroy], :controller => 'site'
    resources :forms do
      member do
        get 'copy'
      end
      resources :fields, :controller => 'form_fields',
        :except => [:index, :new] do
        resources :options, :controller => 'form_field_options',
          :except => [:index, :new]
      end
      resources :fills, :controller => 'filled_forms'
    end
    resources :payments
    resources :audit_logs
  end
  
  # Redirect to SSL from non-SSL so you don't get 404s
  # Repeat for any custom Devise routes
  #match "/users(/*path)", :to => redirect { |_, request|
  #  "https://" + request.host_with_port + request.fullpath }
  #match "/accounts(/*path)", :to => redirect { |_, request|
  #  "https://" + request.host_with_port + request.fullpath }

  get "home/index"
  get "calendar", :controller => 'calendar', :action => 'month',
    :as => 'main_calendar'
  get "calendar/list", :as => 'main_calendar_list'
  get "calendar/day", :as => 'main_calendar_day'
  get ":page_id/calendar", :controller => 'calendar', :action => 'month',
    :as => 'page_calendar'
  get ":page_id/calendar/list", :controller => 'calendar', :action => 'list',
    :as => 'page_calendar_list'
  get "resources/:resource_id/calendar", :controller => 'calendar',
    :action => 'month', :as => 'resource_calendar'
  get "resources/:resource_id/calendar/list", :controller => 'calendar',
    :action => 'list', :as => 'resource_calendar_list'
  get "search", :to => "search#search"

  root :to => "home#index"

  resources :styles
  resources :resources

  resources :pages do
    member do
      get :edit_for_parent
      get :edit_for_feature
    end
    resources :events do
      resource :recurrence, :only => [:show, :update], :controller => :recurrence
      resource :reservations, :only => [:show, :update]
      resources :invitations, :only => [:index, :update, :destroy] do
        collection do
          post :bulk_create
        end
      end
    end
    resources :documents
    resources :photos
    resources :videos
    resources :contacts
    resources :authorizations
    resources :notes
    resource :feature, :only => [:edit, :update], :controller => :home
    resource :podcast
  end
  
  resources :authors
  resources :messages do
    resources :files, :controller => :message_files
  end
  resources :series, :controller => :message_sets
  resources :books, :only => [:index, :show]
  
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
