class Comment < ActiveRecord::Base
  
  module Parent
    def self.included(base)
      base.has_many :comments, :as => :parent
    end
    
    def comment_status
      Cache.read("#{self.cache_key}.comment_status") do
        override_comment = self.comments.first(:conditions => ['comments.override_status = ? AND comments.status IS NOT NULL', true], :order => 'updated_at DESC')

        override_comment ?
          [override_comment.status || 0, self.comments.maximum(:status, :conditions => ['comments.updated_at > ?', override_comment.updated_at]) || 0].max :
          self.comments.maximum(:status) || 0
      end
    end
    
    def computed_status
      [self.status, self.comment_status].max
    end
  end
  
  def map
    self.parent.map
  end
  
  attr_accessible :message, :status, :override_status
  
  def hierarchy
    self.parent.hierarchy << self
  end
  
  belongs_to :user
  belongs_to :parent, :polymorphic => true

  def parent_node
    parent
  end

  validates_inclusion_of :status, :in => ::Status::Enum.keys, :allow_nil => true
  validates_associated :user
  validates_associated :parent

end
