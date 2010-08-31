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
    return redirect_to(@risk.parent_node.hierarchy) if @risk.save
    render :action => :new
  end
  
  def update
    return render(:action => :edit) unless risk.update_attributes(params[:risk])
    flash[:notice] = "Risk was successfully updated."
    redirect_to risk.parent_node.hierarchy
  end
  
  def destroy
    risk.destroy
    redirect_to risk.parent_node.hierarchy
  end
  
  def edit
  end
  
  def show
  end
  
private

  def risk
    @risk ||= (goal.risks.find(params[:id]) if params[:id])
  end
  
  helper_method :risk
  
end
