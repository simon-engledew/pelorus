class User < ActiveRecord::Base
  
  def hierarchy
    [self]
  end
  
  validates_presence_of :name
  validates_presence_of :email_address
  
  has_many :stakes
  
  before_destroy :has_stakes?
  
  def has_roles?
    stakes.empty? and not Map.exists?(:manager_id => self.id)
  end
  
end
