class User < ActiveRecord::Base

  is_paranoid

  def hierarchy
    [self]
  end
  
  named_scope :ordered, :order => 'name'
  
  named_scope :with_subdomain, lambda {|subdomain| { :conditions => { :subdomain => ['*', subdomain] }}}
  
  validates_presence_of :name

  has_many :stakes
  has_many :comments
  
  before_destroy :has_stakes?
  
  def has_stakes?
    allowed = stakes.empty? and not Map.exists?(:manager_id => self.id)
  end
  
  # :http_authenticatable, :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :registerable, :database_authenticatable, :confirmable, :recoverable, :rememberable, :trackable, :validatable

  # validates_presence_of   :email
  # validates_uniqueness_of :email, :scope => :subdomain, :allow_blank => true
  # validates_format_of     :email, :with  => Devise::EMAIL_REGEX, :allow_blank => true

  # validates_presence_of     :password
  # validates_confirmation_of :password
  # validates_length_of       :password, :within => 6..20, :allow_blank => true

  attr_accessible :email, :name, :password, :password_confirmation, :admin
end
