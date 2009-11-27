ActionController::Routing::Routes.draw do |map|
  
  map.with_options :controller => 'graphs' do |graphs|
    graphs.simple_map_graph '/maps/:map_id/simple_map.:format', :action => 'simple_map'
    graphs.extended_map_graph '/maps/:map_id/extended_map.:format', :action => 'extended_map'
  end
 
  map.resources :maps do |maps|
    maps.resources :stakes
    maps.resources :goals do |goals|
      goals.resources :factors
      goals.resources :risks
      goals.resources :stakes
      goals.resources :supporting_goals
    end
  end
  
  map.resources :users
  map.root :maps

end
