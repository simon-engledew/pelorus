class StakesController < ApplicationController

  def new
    @stake = parent_node.stakes.build
  end

  def create
    @stake = parent_node.stakes.build(params[:stake])
    @stake.map = map
    return redirect_to(@stake.parent_node.hierarchy) if @stake.save
    render :action => :new
  end
  
  def update
    return render(:action => :edit) unless stake.update_attributes(params[:stake])
    flash[:notice] = "Stake was successfully updated."
    redirect_to stake.parent_node.hierarchy
  end

  def destroy
    stake.destroy unless stake.enforced
    redirect_to stake.parent_node.hierarchy
  end
  
  def edit
  end

protected

  def parent_node
    (goal || map)
  end

  def stake
    @stake ||= (parent_node.stakes.find(params[:id]) if params[:id])
  end
  
  helper_method :stake

end
