class GraphsController < ApplicationController

  whitelist :network, :graph
  
  caches_action :network
  
  def network
    return send_data(render_to_string, :filename => 'network.png') if params[:download]
  end
  
  def graph
  end

private

  helper_method :target
  def target
    @target ||= map
  end

end
