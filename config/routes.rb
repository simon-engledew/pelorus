ActionController::Routing::Routes.draw do |map|
  
  map.resources :users, :as => 'stakeholders'
  
  map.devise_for :users, :path_names => { :sign_up => 'register', :sign_in => 'login', :sign_out => 'logout' }

  map.with_options :controller => 'graphs' do |graphs|
    graphs.network_graph '/graphs/maps/:map_id/network.:format', :action => 'network'
  end
  
  map.resources :maps do |maps|
    maps.resources :stakes
    maps.resources :comments
    maps.resources :goals do |goals|
      goals.resources :factors
      goals.resources :risks
      goals.resources :stakes
      goals.resources :supporting_goals
      goals.resources :comments
    end
  end
  
  # map.resources :users
  map.root :maps

end
