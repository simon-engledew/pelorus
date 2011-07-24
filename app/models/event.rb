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
  use_exclusive_scope :model, :polymorphic => true
  
end