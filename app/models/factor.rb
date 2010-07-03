class Factor < ActiveRecord::Base
  
  include Comment::Parent
  
  attr_protected :goal
  
  Priorities = [
    'very_low',
    'low',
    'medium',
    'high',
    'very_high'
  ]
  
  def hierarchy
    self.goal.hierarchy << self
  end
  
  belongs_to :goal

  validates_inclusion_of :priority, :in => Factor::Priorities
  validates_uniqueness_of :name, :scope => :goal_id
  validates_associated :goal
  validates_presence_of :goal_id, :name

  LongDate = %r"(\d{1,2}[-/.]\d{1,2}[-/.]\d{4})"
  ShortDate = %r"(\d{1,2}[-/.]\d{1,2}[-/.]\d{2})"
  Float = /(\d[.]?\d*)\D*/
  Boolean = /([YN])/
  
  def self.parse_target(target)
    case target
      when /^([<>])\s*#{ShortDate}$/ then return [$1, Date.strptime($2, '%d/%m/%y')]
      when /^([<>])\s*#{LongDate}$/ then return [$1, Date.strptime($2, '%d/%m/%Y')]
      when /^([=<>])\s*#{Float}$/ then return [$1, Float($2)]
      when /^(=)?\s*#{Boolean}$/ then return [$1, $2]
    end
    return nil
  rescue
    return nil
  end
  
  def self.parse_quantifier(quantifier)
    case quantifier
      when /^#{ShortDate}$/ then return Date.strptime($1, '%d/%m/%y')
      when /^#{LongDate}$/ then return Date.strptime($1, '%d/%m/%Y')
      when /^#{Float}$/ then return Float($1)
      when /^#{Boolean}$/ then return $1
    end
    return nil
  rescue
    return nil
  end
  
  AdvancedQuantifiers = [:report, :fail, :best, :worst].to_set
  
  def self.compare(a, operator, b)
    return a.send(operator, b) if a and b and a.class == b.class
  end
  
  def parsed_target
    @parsed_target ||= Factor.parse_target(target)
  end
  
  def target_value
    parsed_target.last
  end
  
  [:likely, :report, :fail].each do |quantifier|
    method = :"parsed_#{quantifier}"
    define_method(method) do
      variable = :"@#{method}"
      instance_variable_get(variable) || 
      instance_variable_set(variable, (value = send(quantifier)).blank?? target_value : Factor.parse_quantifier(value))
    end
  end
  
  [:best, :worst].each do |quantifier|
    method = :"parsed_#{quantifier}"
    define_method(method) do
      variable = :"@#{method}"
      instance_variable_get(variable) || 
      instance_variable_set(variable, (value = send(quantifier)).blank?? parsed_likely : Factor.parse_quantifier(value))
    end
  end
  
  def validate
    advanced_values = Set.new
    
    operator, target_value = self.parsed_target
    
    errors.add(:target, 'is not valid') unless target_value
    errors.add(:likely, 'is not valid') unless likely_value = self.parsed_likely
    
    operator = (operator or '=') + '='
    
    if errors.empty?
      AdvancedQuantifiers.each do |field|
        errors.add(field, 'is not valid') unless send(:"parsed_#{field}")
        advanced_values.add(field) unless send(field).blank?
      end
    end
       
    unless advanced_values.empty?
      missing = AdvancedQuantifiers - advanced_values
      
      errors.add(:likely, 'cannot be blank') if likely.blank?
      
      unless missing.empty?
        missing.each { |field| errors.add(field, 'cannot be blank') }
      else
        errors.add(:target, "must be #{operator} than report") unless Factor.compare(target_value, operator, self.parsed_report)
        errors.add(:report, "must be #{operator} than fail") unless Factor.compare(self.parsed_report, operator, self.parsed_fail)
    
        errors.add(:best, "must be #{operator} than likely") unless Factor.compare(self.parsed_best, operator, likely_value)
        errors.add(:likely, "must be #{operator} than worst") unless Factor.compare(likely_value, operator, self.parsed_worst)
      end
    end
  end
  
  def advanced
    AdvancedQuantifiers.any? {|quantifier| not send(quantifier).blank?}
  end
  
  def status
    operator, target_value = self.parsed_target
    operator = (operator or '=') + '='
    
    if self.advanced then
      return Status::Red unless Factor.compare(self.parsed_worst, operator, self.parsed_fail)
      return Status::Amber unless Factor.compare(self.parsed_likely, operator, self.parsed_report)
      return Status::Green
    end
    
    return Factor.compare(self.parsed_likely, operator, target_value) ? Status::Green : Status::Red
  end

  def map
    self.goal.map
  end

  def parent_node
    goal
  end
  
end
