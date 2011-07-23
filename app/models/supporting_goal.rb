class SupportingGoal < ActiveRecord::Base

  is_paranoid

  def hierarchy
    self.goal.hierarchy << self
  end

  belongs_to :goal
  belongs_to :supported_by, :class_name => %(Goal)

  validates_associated :goal, :supported_by
  validates_presence_of :goal_id, :supported_by_id
  
  def validate
    unless self.goal.valid_support_targets.include?(self.supported_by)
      errors.add(:supported_by, 'is not a legal supporting goal')
    end
  end
  
  def siblings?
    self.goal.parent_id == self.supported_by.parent_id
  end
  
  def parent_node
    self.goal
  end
  
  def map
    self.goal.map
  end
  
  use_exclusive_scope :goal
  use_exclusive_scope :supported_by, Goal

end
