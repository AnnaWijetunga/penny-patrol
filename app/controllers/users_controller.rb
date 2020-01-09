class UsersController < ApplicationController

  get '/signup' do # signup page, logged in user can't see signup page
    if !logged_in?
      erb :'users/create_user', :layout => :'not_logged_in_layout'
    else
      redirect_to_home_page
    end
  end

  post '/signup' do # user needs username, email, password to sign up - creates a general category initially
    if params[:username].empty? || params[:email].empty? || params[:password].empty?
      flash[:message] = "Pleae don't leave blank content"
      redirect to '/signup'
    else
      @user = User.create(username:params[:username], email:params[:email], password:params[:password])
      @category = Category.create(name:"General", user_id:@user.id)
      session[:user_id] = @user.id
      flash[:message] = "It's time to add expenses"
      redirect_to_home_page
    end
  end
  
  get '/login' do # login page, loads expenses after login, if logged in, can't see login page
    if logged_in?
      redirect_to_home_page
    else
      erb :index, :layout => :'not_logged_in_layout'
    end
  end
  
  post '/login' do # shows expenses if username exists and password is authenticated
    @user = User.find_by(username:params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to_home_page
    else
      flash[:message] = "We can't find you, Please try again"
      redirect_if_not_logged_in
    end
  end
  
  get '/users/:id/edit' do # user edits info ONLY if logged in
    if logged_in?
        erb :'users/edit_user'
    else
      redirect_if_not_logged_in
    end
  end
  
  patch '/users/:id' do # can't edit and leave blanks
    if !params[:username].empty? && !params[:email].empty? && !params[:password].empty?
      @user = User.find(params[:id])
      @user.update(username:params[:username], email:params[:email], password:params[:password])
      flash[:message] = "Account Updated"
      redirect to "/users/#{@user.id}"
    else
      flash[:message] = "Please don't leave blank content"
      redirect to "/users/#{params[:id]}/edit"
    end
  end
  
  get '/users/:id' do # shows user info if logged in
    if logged_in?
      erb :'users/show'
    else
      redirect_if_not_logged_in
    end
  end

  delete '/users/:id/delete' do # user can delete account if logged in
    if logged_in?
      current_user.delete
      redirect to "/logout"
    else
      redirect_if_not_logged_in
    end
  end
  
  get '/logout' do # user can logout, if logged in - can't if not
    if logged_in?
      session.clear
      redirect_if_not_logged_in
    else
      redirect to "/"
    end
  end
  
end