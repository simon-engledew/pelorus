class Comment < ActiveRecord::Base
  
  attr_accessible :message
  
  def hierarchy
    self.parent.hierarchy << self
  end
  
  belongs_to :user
  belongs_to :parent, :polymorphic => true

  def parent_node
    parent
  end

  validates_associated :user
  validates_associated :parent
  
end
