IotPrinterFront::Application.routes.draw do

  # Omniauth
  match "/auth/google/callback" => "sessions#create"
  match "/auth/twitter/callback" => "users#twitter_callback"
  match "/auth/failure" => "sessions#failure"

  # Preview
  match '/preview' => 'home#print_debug'

  # User settings
  get "/user/settings" => "users#settings", :as => :user_settings
  post "/user/settings" => "users#update", :as => :user_settings
  delete "/user/twitter" => "users#destroy_twitter"
  delete "/user" => "users#destroy", :as => :user

  # Sessions
  match "/logout" => "sessions#destroy"
  match "/login" => "home#login", :as => :login

  # Printout management
  resources :printouts, :only => [:index, :show, :destroy]

  # Printer endpoint
  get "/printer/#{APP_CONFIG[:printer_key]}" => "home#printer", :as => "printer"

  # Print-on-demand.
  post "/print" => "home#print"

  # Administration
  namespace :admin do
    get '/' => "home#index"
    get '/settings' => "home#settings"
    get '/printer' => "home#printer"
    get '/ino_printer_remote.ino' => "home#printer_file", :as => "printer_file"
    resources :users, :except => [:show, :new, :create] do
      member do 
        post "login_as"
      end
    end
  end

  root :to => "home#index"
end
