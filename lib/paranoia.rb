require 'active_record'

module Paranoia
  
  def is_paranoid
    include InstanceMethods
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