class UsersController < ApplicationController
  
  def index
    @users = User.with_subdomain(current_subdomain).ordered.all
  end
  
  def new
    @user = User.new
  end
  
  def edit
  end
  
  include ActionView::Helpers::TextHelper
  
  def destroy
    Event.create!(:controller => self, :model => resource) if user.destroy else (flash[:error] = %(Cannot delete the stakeholder "#{user.name}" until #{pluralize user.stakes.count, 'stakes'} have been reassigned.))
    redirect_to users_url
  end
  
  def create
    @user = User.new(params[:user])
    @user.subdomain = current_subdomain
    if @user.save
      Event.create!(:controller => self, :model => resource)
      return redirect_to(@user)
    end
    render :action => :new
  end
  
  def update
    return render(:action => :edit) unless user.update_attributes(params[:user])
    Event.create!(:controller => self, :model => resource)
    flash[:notice] = "User was successfully updated."
    redirect_to user.hierarchy
  end
  
  def show
  end

protected

  def user
    @user ||= (User.with_subdomain(current_subdomain).find_by_id!(params[:id]) if params[:id])
  end
  
  helper_method :user
  
end
