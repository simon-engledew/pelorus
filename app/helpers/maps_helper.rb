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
    goals = parent.children_to_depth(2)

    parent.children.each do |node|
      
      leafs = Set.new
      
      if node.children.empty?
        leafs.add(node)
      else
        node.children.each do |goal|
          leafs.add(goal) unless goal.children.any? {|child| goals.include?(child) }
        end
      end
      
      until leafs.empty?
      
        considered = Set.new
        considering = Set.new
        considering.add(leafs.first)
      
        until considering.empty?
          target = considering.first
          target.supports.each do |supporting_goal|
            
            considering.add(supporting_goal) if leafs.include?(supporting_goal)
            leafs.delete(supporting_goal)
            
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
