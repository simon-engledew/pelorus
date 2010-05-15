ActionController::Routing::Routes.draw do |map|
  
  map.resources :users, :as => 'stakeholders'
  
  map.devise_for :users, :path_names => { :sign_up => 'register', :sign_in => 'login', :sign_out => 'logout' }

  map.with_options :controller => 'graphs' do |graphs|
    graphs.network_graph '/graphs/maps/:map_id/network.:format', :action => 'network'
  end

  map.resources :comments, :path_prefix => ':parent_node_type/:parent_node_id', :requirements => {:parent_node_type => '/goals|maps/factors|risks/', :parent_node_id => '\d+'}
  map.resources :maps do |maps|
    maps.resources :stakes
    maps.resources :goals do |goals|
      goals.resources :factors
      goals.resources :risks
      goals.resources :stakes
      goals.resources :supporting_goals
    end
  end
  
  # map.resources :users
  map.root :maps

end
