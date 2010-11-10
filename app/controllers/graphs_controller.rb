class GraphsController < ApplicationController

  whitelist :network, :graph
  
  caches_action :network
  
  def network
  end
  
  def graph
  end

private

  helper_method :target
  def target
    @target ||= map
  end

end
