class Stake < ActiveRecord::Base
  
  is_paranoid
  
  attr_protected :enforced, :map, :goal

  belongs_to :user
  belongs_to :map
  belongs_to :goal

  validates_associated :user
  validates_presence_of :user
  
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [:map_id, :goal_id]
  
  def validate
    Errors.add(:base, 'Cannot change name on enfored stake') if name_changed? and self.enforced unless new_record?
  end
  
  def hierarchy
    self.parent_node.hierarchy << self
  end
  
  def parent_node
    self.goal || self.map
  end
  
end
