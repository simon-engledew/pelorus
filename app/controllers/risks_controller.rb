class RisksController < ApplicationController

  cache_sweeper :graph_sweeper

  def index
    redirect_to goal.hierarchy
  end

  def new
    @risk = goal.risks.build
  end
  
  def create
    @risk = goal.risks.build(params[:risk])
    if @risk.save
      Event.create!(:controller => self, :model => resource)
      return redirect_to(@risk.parent_node.hierarchy)
    end
    render :action => :new
  end
  
  def update
    return render(:action => :edit) unless risk.update_attributes(params[:risk])
    Event.create!(:controller => self, :model => resource)
    flash[:notice] = "Risk was successfully updated."
    redirect_to risk.parent_node.hierarchy
  end
  
  def destroy
    risk.destroy
    Event.create!(:controller => self, :model => resource)
    redirect_to risk.parent_node.hierarchy
  end
  
  def edit
  end
  
  def show
  end
  
protected

  def risk
    @risk ||= (goal.risks.find_by_id!(params[:id]) if params[:id])
  end
  
  helper_method :risk
  
end
