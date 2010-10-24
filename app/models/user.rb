class User < ActiveRecord::Base

  def hierarchy
    [self]
  end
  
  default_scope :order => 'name'
  
  named_scope :with_subdomain, lambda {|subdomain| { :conditions => { :subdomain => ['*', subdomain] }}}
  
  validates_presence_of :name

  has_many :stakes
  has_many :comments
  
  before_destroy :has_stakes?
  
  def has_stakes?
    stakes.empty? and not Map.exists?(:manager_id => self.id)
  end
  
  # :http_authenticatable, :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :registerable, :database_authenticatable, :confirmable, :recoverable,
         :rememberable, :trackable, :validatable

  attr_accessible :email, :name, :password, :password_confirmation
end
