module Status
  Enum = {0 => :Green, 1 => :Amber, 2 => :Red}.freeze
  Enum.each{|value, key|Status.const_set(key, value)}
  Color = {0 => '#9cc276', 1 => 'darkorange', 2 => '#f4382c'}  
end