class GraphSweeper < ActionController::Caching::Sweeper
  
  observe Goal, Map, Risk, Factor, SupportingGoal, Comment
  
  def after_create(model)
    expire_caches(model)
  end

  def after_update(model)
    expire_caches(model)
  end
  
  def after_destroy(model)
    expire_caches(model)
  end
  
private

  def expire_caches(model)
    [:svg, :png].each do |format|
      expire_action(:controller => :graphs, :action => :network, :map_id => model.map.id, :format => format)
    end
  end
  
end
