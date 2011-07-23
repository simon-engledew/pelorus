class FactorsController < ApplicationController

  cache_sweeper :graph_sweeper

  def index
    redirect_to goal.hierarchy
  end

  def show
    # redirect_to edit_map_goal_factor_path(map, goal, factor) if write_permission?
  end
  
  def new
    @factor = goal.factors.build
  end
  
  def create
    @factor = goal.factors.build(params[:factor])
    if @factor.save
      Event.create!(:controller => self, :model => resource)
      return redirect_to(@factor.parent_node.hierarchy)
    end
    render :action => :new
  end
  
  def update
    return render(:action => :edit) unless factor.update_attributes(params[:factor])
    Event.create!(:controller => self, :model => resource)
    flash[:notice] = "Factor was successfully updated."
    redirect_to factor.parent_node.hierarchy
  end
  
  def destroy
    factor.destroy
    Event.create!(:controller => self, :model => resource)
    redirect_to factor.parent_node.hierarchy
  end
  
  def edit
  end

protected

  def factor
    @factor ||= (goal.factors.find_by_id!(params[:id]) if params[:id])
  end
  
  helper_method :factor

end
