class FactorsController < ApplicationController

  cache_sweeper :map_sweeper

  def index
    redirect_to goal.hierarchy
  end

  def show
  end
  
  def new
    @factor = goal.factors.build
  end
  
  def create
    @factor = goal.factors.build(params[:factor])
    return redirect_to(@factor.hierarchy) if @factor.save
    render :action => :new
  end
  
  def update
    return render(:action => :edit) unless factor.update_attributes(params[:factor])
    flash[:notice] = "Factor was successfully updated."
    redirect_to factor.hierarchy
  end
  
  def destroy
    factor.destroy
    redirect_to factor.parent_node.hierarchy
  end
  
  def edit
  end

protected

  def factor
    @factor ||= goal.factors.find(params[:id])
  end
  
  helper_method :factor

end
