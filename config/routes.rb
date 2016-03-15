Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  get "hyper_home/index"

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
        get 'fills', :controller => 'filled_forms', :action => 'user_index'
        get 'payments', :controller => 'payments', :action => 'user_index'
      end
    end
    devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions"}
    resource :site, :except => [:show, :destroy], :controller => 'site'
    resources :forms do
      member do
        get 'copy'
        get 'edit_contents', :controller => 'form_contents', :action => 'edit'
        post 'update_contents', :controller => 'form_contents', :action => 'update'
      end
      resources :fills, :controller => 'filled_forms' do
        collection do
          get 'user'
        end
      end
    end
    resources :payments do
      member do
        post 'notify'
      end
    end
    resources :audit_logs do
      member do
        get 'details'
      end
    end
    resources :email_lists do
      collection do
        post 'replace_address'
        get 'search'
      end
      member do
        get 'subscribe'
        post 'add'
        get 'unsubscribe'
        post 'remove'
      end
    end
    resources :holidays
  end

  # Redirect to SSL from non-SSL so you don't get 404s
  # Repeat for any custom Devise routes
  %w(users accounts forms form_contents payments audit_logs email_lists
    holidays).each do |area|
    ###match
    get "/#{area}(/*path)", :to => redirect { |_, request|
      "https://" + request.host_with_port + request.fullpath }
  end

  get "site", :controller => 'site', :action => 'show'
  get "home/index"
  get "private", :controller => 'home', :action => 'private'
  get "hyper", :controller => 'hyper_home', :action => 'index'
  get "hyper/index", :controller => 'hyper_home', :action => 'index'
  get "calendar", :controller => 'calendar', :action => 'index',
    :as => 'main_calendar'
  get "calendar/suggestions", :controller => 'calendar', :action => 'suggestions',
    :as => 'calendar_suggestions'
  get "calendar/month", :as => 'main_calendar_month'
  get "calendar/list", :as => 'main_calendar_list'
  get "calendar/day", :as => 'main_calendar_day'
  get ":page_id/calendar", :controller => 'calendar', :action => 'index',
    :as => 'page_calendar'
  get ":page_id/calendar/month", :controller => 'calendar', :action => 'month',
    :as => 'page_calendar_month'
  get ":page_id/calendar/list", :controller => 'calendar', :action => 'list',
    :as => 'page_calendar_list'
  get ":page_id/calendar/day", :controller => 'calendar', :action => 'day',
    :as => 'page_calendar_day'
  get "resources/:resource_id/calendar", :controller => 'calendar',
    :action => 'index', :as => 'resource_calendar'
  get "resources/:resource_id/calendar/month", :controller => 'calendar',
    :action => 'month', :as => 'resource_calendar_month'
  get "resources/:resource_id/calendar/list", :controller => 'calendar',
    :action => 'list', :as => 'resource_calendar_list'
  get "resources/:resource_id/calendar/day", :controller => 'calendar',
    :action => 'day', :as => 'resource_calendar_day'
  get "search", :to => "search#search"
  get "search_events", :controller => 'events', :action => 'search'

  root :to => "home#index"

  resources :styles
  resources :resources do
    member do
      get :delete
    end
  end
  resources :newsletters do
    member do
      post :deliver
    end
  end
  resources :libraries

  ###match
  get '/messages.rss', :to => "podcasts#show", :format => 'rss', :as => 'messages_podcast'
  ###match
  get '/library/sermons.rss' => redirect('/messages.rss')
  ###match
  get '/:page_id.rss', :to => "podcasts#show", :format => 'rss', :as => 'friendly_page_podcast'

  resources :pages do
    collection do
      get :search
    end
    member do
      get :edit
      get :edit_contents
      patch :update_contents_order
    end
    resources :elements, :only => [:new, :create, :edit, :update, :destroy],
      :controller => :page_elements
    #resources :documents
    #resources :photos
    #resources :videos do
    #  resources :users_videos
    #end
    #resources :audios
    resources :contacts do
      member do
        get :email
        post :send_email
      end
    end
    resources :authorizations
    #resources :notes
    resources :texts
    resources :items
    resource :podcast
    #resource :social, :only => [:edit, :update], :controller => :social
    resources :conversations do
      resources :comments
    end
  end

  resources :events do
    resource :recurrence, :only => [:edit, :update], :controller => :recurrence
    resource :reservations, :only => [:edit, :update]
    resources :invitations, :only => [:index, :new, :update, :destroy] do
      collection do
        post :bulk_create
      end
    end
    # resource :share, :only => [:show, :update], :controller => :shared_events
  end

  resources :authors
  resources :messages do
    resources :files, :controller => :message_files
    collection do
      get :suggestions
      get :map_old_file
    end
  end
  ###match
  get 'messages/map_old_file/*file_name', :to => 'messages#map_old_file'
  resources :series, :controller => :message_sets
  resources :books, :only => [:index, :show]
  resource :podcast

  ###match
  get '/:id', :to => "pages#show", :as => 'friendly_page'

  # redirects from old sites
  ###match
  get '/:page/events' => redirect("/%{page}/calendar")
  ###match
  get '/:page/day' => redirect("/%{page}/calendar")
  ###match
  get '/library/files/html/:file_name.:format' => redirect("/messages/map_old_file/%{file_name}.%{format}")
  ###match
  get '/dp/:author/:series/:file_name.:format' => redirect("/messages/map_old_file/%{file_name}.%{format}")
  ###match
  get '/dp/:author/:file_name.:format' => redirect("/messages/map_old_file/%{file_name}.%{format}")
  ###match
  get '/files/messages/:message_id/:file_name.:format' => redirect("/messages/map_old_file/%{file_name}.%{format}")
  ###match
  get '/message_sets/:id' => redirect("/messages")

end
