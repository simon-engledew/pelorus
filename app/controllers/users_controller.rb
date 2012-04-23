class UsersController < ApplicationController
  
  def index
    @users = User.with_subdomain(current_subdomain).ordered.all
    @users = ActiveSupport::OrderedHash.new.tap do |output|
      @users.each do |user|
        (output[user.name.first] ||= []) << user
      end
    end
  end
  
  def new
    @user = User.new
  end
  
  def edit
  end
  
  include ActionView::Helpers::TextHelper
  
  def destroy
    if user == current_user
      flash[:error] = %(You cannot delete yourself)
    elsif user.destroy
      Event.create!(:controller => self, :model => resource)
    else
      flash[:error] = %(Cannot delete the stakeholder "#{user.name}" until #{pluralize user.stakes.count, 'stakes'} have been reassigned.)
    end
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
    @stakes = user.stakes.all(
      :include => {:goal => [:map, :supporting_goals], :map => []},
      #:joins => [:goal, :map],
      #:conditions => ['`goals`.deleted_at IS NULL and `maps`.deleted_at IS NULL'],
      :limit => 50,
      :order => '`stakes`.created_at DESC'
    )
  end

  def write_permission?
    super or (not current_user.nil? and user == current_user)
  end

protected

  def user
    @user ||= (User.with_subdomain(current_subdomain).find_by_id!(params[:id]) if params[:id])
  end
  
  helper_method :user
  
end
