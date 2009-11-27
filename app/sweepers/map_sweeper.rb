class MapSweeper < ActionController::Caching::Sweeper
  
  observe Goal, Map, Risk, Factor, SupportingGoal
  
  def after_create(model)
    expire_caches(model)
  end

  def after_update(model)
    expire_caches(model)
  end
  
private

  def expire_caches(model)
    expire_action(:controller => :maps, :action => :graph, :id => model.map.id, :format => :png)
    expire_action(:controller => :maps, :action => :complex_graph, :id => model.map.id, :format => :png)
  end
  
end