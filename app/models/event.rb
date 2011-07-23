class Event < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :model, :polymorphic => true
  
  def controller=(controller)
    event = self
    controller.instance_eval do
      event.subdomain = self.current_subdomain
      event.user = self.current_user
      event.action = self.action_name
    end
  end
  
  def user_with_exclusive_scope
    event = self
    User.instance_eval do
      self.with_exclusive_scope do
        event.user_without_exclusive_scope
      end
    end
  end
  
  def model_with_exclusive_scope
    event = self
    self.model_type.constantize.instance_eval do
      self.with_exclusive_scope do
        event.model_without_exclusive_scope
      end
    end
  end
  
  alias_method_chain :model, :exclusive_scope
  alias_method_chain :user, :exclusive_scope

end