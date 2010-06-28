module MapsHelper

  def sanitize_label(s)
    s.gsub(/([^A-Za-z0-9 ])/, '')
  end
  
  StatusColor = {0 => '#B5E89F', 1 => 'orange', 2 => '#ffa6a6'}
  
  def status_color(status)
    StatusColor[status]
  end
  
  LineColor = {0 => '#5fa32c', 1 => 'darkorange', 2 => '#c3261c'}
  
  def line_color(status)
    LineColor[status]
  end

end
