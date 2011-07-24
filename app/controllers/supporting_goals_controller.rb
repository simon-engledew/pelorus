class SupportingGoalsController < ApplicationController
  
  cache_sweeper :graph_sweeper

  def new
    @supporting_goal = goal.supporting_goals.build
  end
  
  def create
    @supporting_goal = goal.supporting_goals.build(params[:supporting_goal])
    if @supporting_goal.save
      Event.create!(:controller => self, :model => resource)
      return redirect_to(goal.hierarchy)
    end
    render :action => :new
  end
  
  def destroy
    Event.create!(:controller => self, :model => resource) if supporting_goal.destroy
    redirect_to goal.hierarchy
  end
  
  def supporting_goal
    @supporting_goal ||= (goal.supporting_goals.find_by_id!(params[:id]) if params[:id])
  end

end
