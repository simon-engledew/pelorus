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
    unless goal.cluster?
      return goal
    else
      goal.children.reverse.detect do |child|
        return cluster_target(child)
      end
    end
  end
  
  def invisible_nodes(parent)
    # goals = parent.children_to_depth(2)

    parent.children.each do |node|
      
      leafs = Set.new
      leafs.merge(node.children)
      
      until leafs.empty?
      
        considered = Set.new
        considering = Set.new
        considering.add(leafs.first)
      
        until considering.empty?
          target = considering.first
          (target.supports + target.supported_by).each do |goal|
            considering.add(goal) if leafs.include?(goal)
            leafs.delete(goal)
          end

          considered.add(target)
          considering.delete(target)
        
          leafs.delete(target)
        end
        
        yield(target, leafs.first) if leafs.first
      end
    end
  end

end
