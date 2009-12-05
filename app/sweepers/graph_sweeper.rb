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
    expire_action(:controller => :graphs, :action => :simple_map, :id => model.map.id, :format => :png)
    expire_action(:controller => :graphs, :action => :extended_map, :id => model.map.id, :format => :png)
  end
  
end