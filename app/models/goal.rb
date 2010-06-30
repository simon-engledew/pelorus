class Goal < ActiveRecord::Base

  include Comment::Parent

private
  def self.has_status(*attrs)
    attrs.each do |attr|
      class_eval { define_method("#{attr}_status") { instance_eval { send(attr).map{|o| o.computed_status }.max || 0 }}}
    end
  end
  
public
  def hierarchy
    self.map.hierarchy << self
  end
  
  acts_as_tree
  
  attr_protected :map
  
  has_many :factors
  has_many :risks
  has_many :stakes
  
  has_many :supporting_goals, :dependent => :destroy
  has_many :supported_by, :through => :supporting_goals, :source => :supported_by

  has_many :supported_goals, :class_name => %(SupportingGoal), :foreign_key => :supported_by_id, :dependent => :destroy
  has_many :supports, :through => :supported_goals, :source => :goal
  
  belongs_to :map
  
  has_status :risks, :factors, :supports, :supported_by
  
  validates_presence_of :map_id
  validates_associated  :map, :parent

  validates_length_of :name, :maximum => 50
  validates_uniqueness_of :name, :scope => :map_id
  
  after_create :create_default_stakes
  
  def create_default_stakes
    self.parent_node.stakes.each do |parent_stake|
      stake = self.stakes.build(:name => parent_stake.name, :user => parent_stake.user)
      stake.map = self.map
      stake.enforced = parent_stake.enforced
      stake.save!
    end
  end
  
  def supported_chain(set = Set.new)
    supported_by.select{|goal|goal.propagate}.each do |goal|
      goal.supported_chain(set).add(goal)
    end
    set
  end
  
  def descendants(set = Set.new)
    set.merge children
    children.each{|goal|goal.descendants(set)}
    set
  end

  def valid_support_targets
    graph = self.map.graph
    
    valid_targets = Set.new
    
    invalid_targets = Set.new
    invalid_targets.add(self)
    invalid_targets.merge(descendants)
    invalid_targets.merge(supported_by)
  
    map.goals.each do |goal|
      valid_targets.add(goal) unless invalid_targets.include?(goal) or graph.cyclic?(goal, self)
    end
    
    return valid_targets
  end
  
  def children_status
    children.map{|goal| goal.propagate ? goal.computed_status : 0}.max || 0
  end
  
  def supported_chain_status
    supported_chain.map{|goal| goal.computed_status}.max || 0
  end
  
  def remote_status
    (children.map{|goal| goal.supported_chain_status} << supported_chain_status).max || 0
  end
  
  def computed_status
    status
  end
  
  def status
    [supported_chain_status, local_status].max
  end
  
  def local_status
    [factors_status, risks_status, children_status, comment_status].max
  end

  def parent_node
    parent.nil? ? map : parent
  end
  
end
