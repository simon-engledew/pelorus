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
  
  # def parent_with_exclusive_scope
  #   model = self
  #   self.parent_type.constantize.instance_eval do
  #     self.with_exclusive_scope do
  #       model.parent_without_exclusive_scope
  #     end
  #   end
  # end
  # 
  # alias_method_chain :parent, :exclusive_scope
  
  def use_exclusive_scope(model, options = {})
    options[:class_name] ||= model.to_s.camelize
    self.class_eval do
      define_method(:"#{model}_with_exclusive_scope") do
        instance = self
        (options[:polymorphic] ? instance.send(:"#{model}_type") : options[:class_name]).constantize.instance_eval do
          with_exclusive_scope do
            instance.send(:"#{model}_without_exclusive_scope")
          end
        end
      end
      alias_method_chain(model, :exclusive_scope)
    end
  end
  
  def validates_uniqueness_of_with_deleted(*attr_names)
    configuration = { :case_sensitive => true }
    configuration.update(attr_names.extract_options!)

    validates_each(attr_names,configuration) do |record, attr_name, value|
      # The check for an existing value should be run from a class that
      # isn't abstract. This means working down from the current class
      # (self), to the first non-abstract class. Since classes don't know
      # their subclasses, we have to build the hierarchy between self and
      # the record's class.
      class_hierarchy = [record.class]
      while class_hierarchy.first != self
        class_hierarchy.insert(0, class_hierarchy.first.superclass)
      end

      # Now we can work our way down the tree to the first non-abstract
      # class (which has a database table to query from).
      finder_class = class_hierarchy.detect { |klass| !klass.abstract_class? }

      column = finder_class.columns_hash[attr_name.to_s]

      if value.nil?
        comparison_operator = "IS ?"
      elsif column.text?
        comparison_operator = "#{connection.case_sensitive_equality_operator} ?"
        value = column.limit ? value.to_s.mb_chars[0, column.limit] : value.to_s
      else
        comparison_operator = "= ?"
      end

      sql_attribute = "#{record.class.quoted_table_name}.#{connection.quote_column_name(attr_name)}"

      if value.nil? || (configuration[:case_sensitive] || !column.text?)
        condition_sql = "#{sql_attribute} #{comparison_operator}"
        condition_params = [value]
      else
        condition_sql = "LOWER(#{sql_attribute}) #{comparison_operator}"
        condition_params = [value.mb_chars.downcase]
      end

      if scope = configuration[:scope]
        Array(scope).map do |scope_item|
          scope_value = record.send(scope_item)
          condition_sql << " AND " << attribute_condition("#{record.class.quoted_table_name}.#{connection.quote_column_name(scope_item)}", scope_value)
          condition_params << scope_value
        end
      end

      unless record.new_record?
        condition_sql << " AND #{record.class.quoted_table_name}.#{record.class.primary_key} <> ?"
        condition_params << record.send(:id)
      end

      condition_sql << " AND #{record.class.quoted_table_name}.deleted_at is NULL"

      finder_class.with_exclusive_scope do
        if finder_class.exists?([condition_sql, *condition_params])
          record.errors.add(attr_name, :taken, :default => configuration[:message], :value => value)
        end
      end
      
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

class << ActiveRecord::Base
  alias_method_chain :validates_uniqueness_of, :deleted
end
