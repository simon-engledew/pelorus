class Map < ActiveRecord::Base

  DefaultStakes = ['Goal Champion', 'Goal Manager', 'Risk Manager', 'Change Manager'].freeze

  def hierarchy
    [self]
  end

  validates_uniqueness_of :name
  validates_presence_of :name
  
  has_many :goals
  has_many :roles
  has_many :stakes, :conditions => {:goal_id => nil}
  has_many :comments, :as => :parent
  
  validates_associated :manager
  validates_presence_of :manager
  belongs_to :manager, :class_name => User.to_s
  
  after_create :create_default_stakes
  
  def create_default_stakes
    DefaultStakes.each do |name|
      stake = self.stakes.build(:name => name, :user => self.manager)
      stake.enforced = true
      stake.save!
    end
  end
  
  def children
    goals.find :all, :conditions => {:parent_id => nil}
  end
  
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
    children.map{|goal| goal.propagate ? goal.status : 0 }.max || 0
  end
  
  def map
    self
  end
  
  def parent_node
    nil
  end
  
end
