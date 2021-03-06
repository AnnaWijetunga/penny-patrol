require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base

  use Rack::Flash

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "quite_secure"
  end

  get '/' do
    if !logged_in?
      erb :index
    else
      redirect_to_home_page
    end
  end

  helpers do

    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end

    def redirect_if_not_logged_in
      if !logged_in?
        redirect "/login"
      end
    end

    def redirect_to_home_page
      redirect to "/expenses"
    end

    def redirect_to_categories
      redirect to "/categories"
    end

  end

end
