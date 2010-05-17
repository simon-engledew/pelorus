class User < ActiveRecord::Base

  def hierarchy
    [self]
  end
  
  validates_presence_of :name

  has_many :stakes
  has_many :comments
  
  before_destroy :has_stakes?
  
  def has_stakes?
    stakes.empty? and not Map.exists?(:manager_id => self.id)
  end
  
  # :http_authenticatable, :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :registerable, :authenticatable, :confirmable, :recoverable,
         :rememberable, :trackable, :validatable

  attr_accessible :email, :name, :password, :password_confirmation
end
