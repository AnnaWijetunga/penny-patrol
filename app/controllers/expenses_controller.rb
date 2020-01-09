class ExpensesController < ApplicationController

    get '/expenses' do # user views all expenses if logged in - or is directed to login
      if logged_in?
        erb :'expenses/expenses'
      else
        redirect_if_not_logged_in
      end
    end
  
    get '/expenses/new' do # user creates expense, if logged in
      if logged_in?
        erb :'/expenses/create_expense'
      else
        redirect_if_not_logged_in
      end
    end
  
    post '/expenses' do # user can't leave a blank expense
      if params[:description].empty? || params[:amount].empty? || params[:date].empty? || params[:category_name].empty?
        flash[:message] = "Please don't leave blank content"
        redirect to "/expenses/new"
      else
        @user = current_user
        @category = @user.categories.find_or_create_by(name:params[:category_name])
        @category.user_id = @user.id
        @expense = Expense.create(description:params[:description], amount:params[:amount], date:params[:date], category_id:@category.id, user_id:@user.id)
        redirect to "/expenses/#{@expense.id}"
      end
    end

    get '/expenses/:id' do # shows one expense
      if logged_in?
        @expense = Expense.find(params[:id])
        erb :'expenses/show_expense'
      else
        redirect_if_not_logged_in
      end
    end
  
    get '/expenses/:id/edit' do # user can edit their own expense if logged in
      if logged_in?
        @expense = Expense.find(params[:id])
        @category = Category.find(@expense.category_id)
        if @expense.user_id == current_user.id
          erb :'expenses/edit_expense'
        else
          redirect_to_home_page
        end
      else
        redirect_if_not_logged_in
      end
    end
  
    patch '/expenses/:id' do # user can edit leaving blanks
      if !params[:description].empty? && !params[:amount].empty? && !params[:date].empty?
        @expense = Expense.find(params[:id])
        @expense.update(description:params[:description], amount:params[:amount], date:params[:date])
        @category = current_user.categories.find_by(name:params[:category_name])
        @expense.category_id = @category.id
        @expense.save
        flash[:message] = "Your Expense Has Been Succesfully Updated"
        redirect_to_home_page
      else
        flash[:message] = "Please Don't Leave Blank Content"
        redirect to "/expenses/#{params[:id]}/edit"
      end
    end
  
    delete '/expenses/:id/delete' do # user can delete their own expense if logged in
      if logged_in?
        @expense = Expense.find(params[:id])
        if @expense.user_id == current_user.id
          @expense.delete
          flash[:message] = "Your expense has been deleted successfully"
          redirect_to_home_page
        end
      else
        redirect_if_not_logged_in
      end
    end
  
end