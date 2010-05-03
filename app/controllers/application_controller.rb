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

  #before_filter :authenticate #if Rails.env.production?

protected
  def self.whitelist(*actions)
    @@whitelist = actions.map(&:to_s).to_set
  end
  
  def map
    @map ||= (Map.find(params[:map_id]) if params[:map_id])
  end
  
  def goal
    @goal ||= (map.goals.find_by_id(params[:goal_id]) if params[:goal_id])
  end
  
  def resource
    @resource ||= send(controller_name.singularize)
  end
  
  def check_permissions
    whitelist = self.class.instance_eval { class_variable_get(:@@whitelist) }
    raise NotFound.new("access to #{controller_name}##{action_name} denied. available actions are #{whitelist.to_a.to_sentence}") unless write_permission? || whitelist.include?(action_name)
  end
  
  
  def write_permission?
    user_signed_in? ? current_user.admin : false
  end

  whitelist :show, :index
  
  helper_method :map, :goal, :resource, :title, :write_permission?
  
  before_filter :check_permissions, :unless => lambda { |controller| controller.kind_of?(SessionsController) } # controller.devise_controller? }
    # controller.kind_of?(SessionsController)
  # end # || controller.kind_of?(ConfirmationsController)}
end
