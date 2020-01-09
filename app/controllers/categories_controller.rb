class CategoriesController < ApplicationController

  get '/categories' do # user views expense categories if logged in
    if logged_in?
      @categories = current_user.categories.all
      erb :'categories/categories'
    else
      redirect_if_not_logged_in
    end
  end

  post '/categories' do # user can't create a blank category
    if params[:name].empty?
      flash[:message] = "Please Enter a Category Name"
      redirect_to_categories
    else
      @user = current_user
      @category = Category.create(name:params[:name], user_id:@user.id)
      redirect_to_categories
    end
  end

  get '/categories/:id' do # displays one category
    if logged_in?
      @category = Category.find(params[:id])
      erb :'categories/show_category'
    else
      redirect_if_not_logged_in
    end
  end

  get '/categories/:id/edit' do # user can edit a category if logged in, but doesn't let user edit a category not createed by themselves
    if logged_in?
      @category = Category.find(params[:id])
      if @category.user_id == current_user.id
        erb :'categories/edit_category'
      else
        redirect_to_categories
      end
    else
      redirect_if_not_logged_in
    end
  end

  patch '/categories/:id' do # user can't leave blanks
    if !params[:name].empty?
      @category = Category.find(params[:id])
      @category.update(name:params[:name])
      flash[:message] = "Your category has been updated successfully"
      redirect_to_categories
    else
      flash[:message] = "Please don't leave blank content"
      redirect to "/categories/#{params[:id]}/edit"
    end
  end

  delete '/categories/:id/delete' do # user can delete their own category, if logged in, can't delete what they didn't create
    if logged_in?
      if current_user.categories.size == 1
        flash[:message] = "You need at least one category"
        redirect_to_categories
      else
        @category = Category.find(params[:id])
        if @category.user_id == current_user.id
          @category.destroy
          flash[:message] = "Your category has been deleted successfully"
          redirect_to_categories
        end
      end
    else
      redirect_if_not_logged_in
    end
  end

  get '/categories/expenses/:id/edit' do # helper route - to edit expenses when the erb file adds '/categories' to the edit link
    if logged_in?
      @expense = Expense.find(params[:id])
      @category = Category.find(@expense.category_id)
      if @expense.user_id == session[:user_id]
        erb :'expenses/edit_expense'
      else
        redirect_to_home_page
      end
    else
      redirect_if_not_logged_in
    end
  end

end