module MapsHelper

  def sanitize_label(s)
    s.gsub(/([^A-Za-z0-9 ])/, '')
  end
  
  def status_color(status)
    Status::Color[status]
  end
  
  LineColor = {0 => '#5fa32c', 1 => 'darkorange', 2 => '#c3261c'}
  
  def line_color(status)
    LineColor[status]
  end

end
