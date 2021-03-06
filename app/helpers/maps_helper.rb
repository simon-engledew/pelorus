module MapsHelper

  def timeline_action_icon(event)
    text = translate("timeline.index.action.#{event.action}").capitalize

    image_tag "/images/icons/#{event.action}.png", :title => text, :alt => text
  end

  def sanitize_label(s)
    s.gsub('\\', '\\\\\\').gsub('"', '\"')
  end
  
  StatusColor = {0 => '#dff7d1', 1 => '#ffe096', 2 => '#ffcdcd'}
  
  def status_color(status)
    StatusColor[status]
  end
  
  LineColor = {0 => '#50a420', 1 => '#ff8e00', 2 => '#c3261c'}
  
  def line_color(status)
    LineColor[status]
  end

  def cluster_head(goal)
    unless goal.cluster?
      return goal
    else
      return ordered_goals(goal.children).last
    end
  end
  
  def cluster_tail(goal)
    unless goal.cluster?
      return goal
    else
      return ordered_goals(goal.children).first
    end
  end
  
  def ordered_goals(goals)
    goals.sort_by{|goal|goal.name}.sort_by{|goal|(goal.head? and goal.tail?)? 3 : goal.head?? 2 : goal.tail?? 0 : 1}
  end
  
  def invisible_nodes(parent)
    # goals = parent.children_to_depth(2)

    parent.children.each do |node|
      
      leafs = Set.new
      leafs.merge(node.children)
      leafs = ordered_goals(leafs)
      
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
