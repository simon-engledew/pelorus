class StakesController < ApplicationController

  def new
    @stake = parent_node.stakes.build
  end

  def create
    @stake = parent_node.stakes.build(params[:stake])
    @stake.map = map
    if @stake.save
      Event.create!(:controller => self, :model => resource)
      return redirect_to(@stake.parent_node.hierarchy)
    end
    render :action => :new
  end
  
  def update
    return render(:action => :edit) unless stake.update_attributes(params[:stake])
    Event.create!(:controller => self, :model => resource)
    flash[:notice] = "Stake was successfully updated."
    redirect_to stake.parent_node.hierarchy
  end

  def destroy
    return redirect_to(stake.parent_node.hierarchy) unless stake.enforced
    stake.destroy
    Event.create!(:controller => self, :model => resource)
    redirect_to stake.parent_node.hierarchy
  end
  
  def edit
  end

protected

  def parent_node
    (goal || map)
  end

  def stake
    @stake ||= (parent_node.stakes.find_by_id!(params[:id]) if params[:id])
  end
  
  helper_method :stake

end
