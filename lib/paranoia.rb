require 'active_record'

module Paranoia
  
  def is_paranoid
    include InstanceMethods
  end
  
  # def user_with_exclusive_scope
  #   model = self
  #   User.instance_eval do
  #     self.with_exclusive_scope do
  #       model.user_without_exclusive_scope
  #     end
  #   end
  # end
  
  def use_exclusive_scope(model, klass = model.to_s.camelize.constantize)
    self.class_eval do
      define_method(:"#{model}_with_exclusive_scope") do
        instance = self
        klass.instance_eval do
          with_exclusive_scope do
            instance.send(:"#{model}_without_exclusive_scope")
          end
        end
      end
      alias_method_chain(model, :exclusive_scope)
    end
  end
  
  module InstanceMethods
    def self.included(base)
      base.class_eval do
        base.default_scope :conditions => {:deleted_at => nil}
      end
    end
    
    def destroyed?
      not self.deleted_at.nil?
    end
    
    def destroy_without_callbacks
      self.update_attribute(:deleted_at, Time.now.utc).tap do
        freeze
      end
    end

    def destroy
      return false if callback(:before_destroy) == false
      result = destroy_without_callbacks
      callback(:after_destroy)
      result
    end
  end
end

ActiveRecord::Base.send(:extend, Paranoia)