class Event < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :model, :polymorphic => true
  belongs_to :map
  
  named_scope :with_subdomain, lambda {|subdomain| { :conditions => { :subdomain => subdomain }}}
  named_scope :latest, lambda {|n| { :order => 'updated_at DESC', :limit => n }}

  def model=(model)
    write_attribute(:model_id, model.id)
    write_attribute(:model_type, model.class.to_s)
    write_attribute(:map_id, model.map.id) if model.respond_to?(:map)
  end

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