class GoalsController < ApplicationController
  
  cache_sweeper :graph_sweeper
  
  def index
    redirect_to map.hierarchy
  end
  
  def new
    @goal = map.goals.build
    @goal.parent = Goal.find_by_id!(params[:parent_id]) if params[:parent_id]
  end
  
  def create
    @goal = map.goals.build(params[:goal])
    if @goal.save
      Event.create!(:controller => self, :model => resource)
      return redirect_to(@goal.hierarchy)
    end
    render :action => :new
  end
  
  def update
    return render(:action => :edit) unless goal.update_attributes(params[:goal])
    Event.create!(:controller => self, :model => resource)
    flash[:notice] = "Goal was successfully updated."
    redirect_to @goal.hierarchy
  end
  
  def destroy
    Event.create!(:controller => self, :model => resource) if goal.destroy
    redirect_to goal.parent_node.hierarchy
  end

  def edit
  end
  
  def show
  end

protected

  def goal
    @goal ||= (map.goals.find_by_id!(params[:id]) if params[:id])
  end
  
end
