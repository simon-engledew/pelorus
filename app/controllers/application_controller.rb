# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '8a5dd884526ac05917c19f058266084b'

  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  before_filter :authenticate #if Rails.env.production?
  before_filter :check_permissions

protected
  attr_accessor :title

  def authenticate
    authenticate_or_request_with_http_basic('Pelorus') do |username, password|
      (user = Settings['users'][username] and user['password'] == password).tap do |authenticated|
        @write_permission = user['write_permission'] if authenticated
      end
    end
  end
  
  def check_permissions
    raise NotFound unless write_permission? || (['show', 'index'].to_set + (
      self.class.const_defined?('ActionWhitelist') ?
        self.class.const_get('ActionWhitelist').map{|o|o.to_s}.to_set :
        Set.new
    )).include?(action_name)
  end

  def map
    @map ||= Map.find(params[:map_id])
  end
  
  def goal
    @goal ||= map.goals.find_by_id(params[:goal_id])
  end
  
  def resource
    @resource ||= send(controller_name.singularize)
  end
  
  def write_permission?
    @write_permission
  end
  
  helper_method :map, :goal, :resource, :title, :write_permission?
  
end
