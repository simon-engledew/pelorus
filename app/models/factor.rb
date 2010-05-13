class Factor < ActiveRecord::Base
  
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
  
  # validates_presence_of :status, :message => 'cannot be calculated'

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
  
  DetailedQuantifiers = [:report, :fail, :best, :worst].to_set
  
  def self.compare(a, operator, b)
    return a.send(operator, b) if a and b and a.class == b.class
  end
  
  def validate
    parsed_values = {}
    
    operator, target_value = Factor.parse_target(target)
    
    errors.add(:target, 'is not valid') unless target_value
    errors.add(:likely, 'is not valid') unless likely_value = Factor.parse_quantifier(likely)
    
    operator = (operator or '=') + '='
    
    DetailedQuantifiers.each do |field|
      value = send(field)
      unless value.blank?
        if Factor.parse_quantifier(value)
          parsed_values[field] = Factor.parse_quantifier(value)
        else
          errors.add(field, 'is not valid')
        end
      end
    end
        
    unless parsed_values.keys.empty?
      missing = DetailedQuantifiers - parsed_values.keys
      unless missing.empty?
        missing.each { |field| errors.add(field, 'cannot be blank') }
      else
        errors.add(:target, "must be #{operator} than report") unless Factor.compare(target_value, operator, parsed_values[:report])
        errors.add(:report, "must be #{operator} than fail") unless Factor.compare(parsed_values[:report], operator, parsed_values[:fail])

        errors.add(:best, "must be #{operator} than likely") unless Factor.compare(parsed_values[:best], operator, likely_value)
        errors.add(:likely, "must be #{operator} than worst") unless Factor.compare(likely_value, operator, parsed_values[:worst])
      end
    end
  end
  
  def status
    operator, target_value = Factor.parse_target(target)
    likely_value = Factor.parse_quantifier(likely)
    
    operator = (operator or '=') + '='
    
    if report_value = Factor.parse_quantifier(report) and fail_value = Factor.parse_quantifier(fail) and worst_value = Factor.parse_quantifier(worst) then
      return Status::Red unless Factor.compare(worst_value, operator, fail_value)
      return Status::Amber unless Factor.compare(likely_value, operator, report_value)
      return Status::Green
    end
    
    return Factor.compare(likely_value, operator, target_value) ? Status::Green : Status::Red
  end

  def map
    self.goal.map
  end

  def parent_node
    goal
  end
  
end
