class Risk < ActiveRecord::Base

  def hierarchy
    self.goal.hierarchy << self
  end
  
  attr_protected :goal
  
  belongs_to :goal
  has_many :comments, :as => :parent

  validates_uniqueness_of :name, :scope => :goal_id
  validates_inclusion_of :status, :in => Status::Enum.keys

  def map
    self.goal.map
  end

  def parent_node
    goal
  end
  
end
