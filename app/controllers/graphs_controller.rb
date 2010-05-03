class GraphsController < ApplicationController
  
  whitelist :network
  
  caches_action  :network
  
  def network
  end

end
