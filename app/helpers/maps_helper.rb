module MapsHelper

  def sanitize_label(s)
    s.gsub(/([^.A-Za-z0-9 ])/, '')
  end
  
  StatusColor = {0 => '#dff7d1', 1 => '#ffe096', 2 => '#ffcdcd'}
  
  def status_color(status)
    StatusColor[status]
  end
  
  LineColor = {0 => '#50a420', 1 => '#ff8e00', 2 => '#c3261c'}
  
  def line_color(status)
    LineColor[status]
  end

  def cluster_target(goal)
    if goal.children.empty?
      return goal
    else
      goal.children.detect do |child|
        return cluster_target(child)
      end
    end
  end

end
