class Map < ActiveRecord::Base

  is_paranoid
  include Comment::Parent

  DefaultStakes = ['Goal Champion', 'Goal Manager', 'Risk Manager', 'Change Manager'].freeze

  def hierarchy
    [self]
  end
  
  named_scope :with_subdomain, lambda {|subdomain| { :conditions => { :subdomain => subdomain }}}

  validates_uniqueness_of :name, :scope => :subdomain
  validates_presence_of :name
  
  attr_protected :manager, :subdomain
  
  has_many :goals, :dependent => :destroy
  # has_many :roles, :dependent => :destroy
  has_many :stakes, :dependent => :destroy, :conditions => {:goal_id => nil}
  
  validates_associated :manager
  validates_presence_of :manager
  belongs_to :manager, :class_name => User.to_s
  
  after_create :create_default_stakes
  
  def create_default_stakes
    DefaultStakes.each do |name|
      self.stakes.create!(:name => name, :user => self.manager) do |stake|
        stake.enforced = true
      end
    end
  end
  
  def children
    goals.find :all, :conditions => {:parent_id => nil}
  end
  
  module ChildrenToDepth
    def children_to_depth(n, set=Set.new)
      if n > 0
        self.children.each do |child|
          set.add(child)
          child.children_to_depth(n - 1, set)
        end
      end
      set
    end
  end
  
  include Map::ChildrenToDepth
  
  def graph
    graph = DirectedGraph.new
    self.goals.each do |goal|
      graph.add(goal)
      goal.children.each{|child| graph.add(child, goal)}
      goal.supporting_goals.each{|supporting_goal| graph.add(supporting_goal.supported_by, supporting_goal.goal)}
    end
    graph
  end
  
  def status
    Cache.read("#{self.cache_key}.status") do
      [children.map{|goal| goal.propagate ? goal.computed_status : 0 }.max || 0, self.comment_status].max
    end
  end
  
  def map
    self
  end
  
  def parent_node
    nil
  end
  
end
