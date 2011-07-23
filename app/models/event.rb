class Event < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :model, :polymorphic => true
  
  named_scope :with_subdomain, lambda {|subdomain| { :conditions => { :subdomain => subdomain }}}
  
  def controller=(controller)
    event = self
    controller.instance_eval do
      event.subdomain = self.current_subdomain
      event.user = self.current_user
      event.action = self.action_name
    end
  end
  
  use_exclusive_scope :user
  
  def model_with_exclusive_scope
    model = self
    self.model_type.constantize.instance_eval do
      self.with_exclusive_scope do
        model.model_without_exclusive_scope
      end
    end
  end
  
  alias_method_chain :model, :exclusive_scope

end