class Comment < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :parent, :polymorphic => true
  
  validates_associated :user
  validates_associated :parent
  
end
