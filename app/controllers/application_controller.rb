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

  before_filter :store_referrer
  def store_referrer
    referrer_path = URI.parse(request.referrer).path
    referrer_route = ActionController::Routing::Routes.recognize_path(referrer_path, :method => :get)

    if ['show', 'index'].include?(referrer_route[:action]) 
      unless referrer_route[:controller] == controller_name and referrer_route[:action] == action_name
        session[:back] = referrer_path
      end
    end
  end

  unless Rails.env.development?
    rescue_from(
      ActionController::RoutingError,
      ActionController::UnknownController,
      ActionController::UnknownAction,
      ActiveRecord::RecordNotFound,
      NotFound,
      :with => :rescue_resource_not_found
    )
    rescue_from ActionView::TemplateError do |exception|
      raise exception.original_exception if exception.original_exception.class.is_a?(ActiveRecord::RecordNotFound)
    end
  end

  def rescue_resource_not_found(exception)
    response.status = 404
    return render :file => Rails.root.join('public', '404.html')
  end

  def self.whitelist(*actions)
    write_inheritable_attribute(:whitelist, (read_inheritable_attribute(:white_list) || Set.new) + actions.map(&:to_s))
  end
  
  def map
    @map ||= (Map.with_subdomain(current_subdomain).find_by_id!(params[:map_id]) if params[:map_id])
  end
  
  def goal
    @goal ||= (map.goals.find_by_id!(params[:goal_id]) if params[:goal_id])
  end
  
  def resource
    send(controller_name.singularize)
  end
  
  def resource_name
    controller_name.singularize
  end
  
  def check_permissions
    whitelist = self.class.read_inheritable_attribute(:whitelist)
    raise NotFound.new("access to #{controller_name}##{action_name} denied. available actions are #{whitelist.to_a.to_sentence}") unless write_permission? || (whitelist && whitelist.include?(action_name))
  end
  
  
  def write_permission?
    user_signed_in? ? current_user.admin : false
  end

  whitelist :show, :index
  
  helper_method :map, :goal, :resource, :resource_name, :write_permission?
  
  before_filter :check_permissions, :unless => lambda { |controller| controller.kind_of?(SessionsController) } # controller.devise_controller? }
    # controller.kind_of?(SessionsController)
  # end # || controller.kind_of?(ConfirmationsController)}
end
