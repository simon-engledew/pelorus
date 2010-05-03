class GoalsController < ApplicationController
  
  cache_sweeper :graph_sweeper
  
  def index
    redirect_to map.hierarchy
  end
  
  def new
    @goal = map.goals.build
    @goal.parent = Goal.find(params[:parent_id]) if params[:parent_id]
  end
  
  def create
    @goal = map.goals.build(params[:goal])
    return redirect_to(@goal.hierarchy) if @goal.save
    render :action => :new
  end
  
  def update
    return render(:action => :edit) unless goal.update_attributes(params[:goal])
    flash[:notice] = "Goal was successfully updated."
    redirect_to @goal.hierarchy
  end
  
  def destroy
    goal.destroy
    redirect_to goal.parent_node.hierarchy
  end

  def edit
  end
  
  def show
  end

protected

  def goal
    @goal ||= (map.goals.find(params[:id]) if params[:id])
  end
  
end
