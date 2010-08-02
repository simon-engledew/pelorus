class GraphsController < ApplicationController
  
  whitelist :network, :graph
  
  caches_action  :network
  
  def network
  end
  
  def graph
  end

end
