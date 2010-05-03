class UsersController < ApplicationController
  
  def index
    @users = User.all
  end
  
  def new
    @user = User.new
  end
  
  def edit
  end
  
  def destroy
    user.destroy
    redirect_to users_url
  end
  
  def create
    @user = User.new(params[:user])
    return redirect_to(@user) if @user.save
    render :action => :new
  end
  
  def update
    return render(:action => :edit) unless user.update_attributes(params[:user])
    flash[:notice] = "User was successfully updated."
    redirect_to user.hierarchy
  end
  
  def show
  end

protected

  def user
    @user ||= (User.find_by_id(params[:id]) if params[:id])
  end
  
  helper_method :user
  
end
