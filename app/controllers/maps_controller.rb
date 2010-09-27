class MapsController < ApplicationController
 
  cache_sweeper :graph_sweeper

  def index
    @maps = Map.with_subdomain(current_subdomain).all(:include => :manager)
  end
  
  def new
    @map = Map.new
  end
  
  def create
    @map = Map.new(params[:map])
    @map.subdomain = current_subdomain
    return redirect_to(@map.hierarchy) if @map.save
    render :action => :new
  end
  
  def update
    return render(:action => :edit) unless map.update_attributes(params[:map])
    flash[:notice] = "Map was successfully updated."
    redirect_to @map.hierarchy
  end
  
  def destroy
    map.destroy
    redirect_to root_url
  end
  
  def edit
  end
  
  def show
  end
  
protected
  def map
    @map ||= (Map.with_subdomain(current_subdomain).find(params[:id]) if params[:id])
  end
end
