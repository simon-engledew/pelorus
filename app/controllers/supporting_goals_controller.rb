class SupportingGoalsController < ApplicationController
  
  cache_sweeper :map_sweeper

  def new
    @supporting_goal = goal.supporting_goals.build
  end
  
  def create
    @supporting_goal = goal.supporting_goals.build(params[:supporting_goal])
    return redirect_to(goal.hierarchy) if @supporting_goal.save
    render :action => :new
  end
  
  def destroy
    supporting_goal.destroy
    
    redirect_to goal.hierarchy
  end
  
  def supporting_goal
    @supporting_goal ||= goal.supporting_goals.find(params[:id])
  end

end
