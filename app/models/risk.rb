class Risk < ActiveRecord::Base

  is_paranoid
  include Comment::Parent

  def hierarchy
    self.goal.hierarchy << self
  end
  
  attr_protected :goal
  
  belongs_to :goal

  validates_uniqueness_of :name, :scope => :goal_id
  validates_presence_of :goal_id, :name
  validates_inclusion_of :status, :in => Status::Enum.keys

  def map
    self.goal.map
  end

  def parent_node
    goal
  end
  
end
