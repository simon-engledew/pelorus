class MapsController < ApplicationController
 
  cache_sweeper :graph_sweeper

  def index
    @maps = Map.with_subdomain(current_subdomain).all(:include => :manager)
    @events = ActiveSupport::OrderedHash.new.tap do |events|
      Event.with_subdomain(current_subdomain).all(:order => "updated_at DESC", :limit => 10).each do |event|
        date = event.updated_at.to_date
        (events[date] ||= []) << event
      end
    end
  end
  
  def new
    @map = Map.new
  end
  
  def create
    @map = Map.new(params[:map])
    @map.subdomain = current_subdomain
    if @map.save
      Event.create!(:controller => self, :model => resource)
      return redirect_to(@map.hierarchy)
    end
    render :action => :new
  end
  
  def update
    return render(:action => :edit) unless map.update_attributes(params[:map])
    Event.create!(:controller => self, :model => resource)
    flash[:notice] = "Map was successfully updated."
    redirect_to @map.hierarchy
  end
  
  def destroy
    Event.create!(:controller => self, :model => resource) if map.destroy
    redirect_to root_url
  end
  
  def edit
  end
  
  def show
  end
  
protected
  def map
    @map ||= (Map.with_subdomain(current_subdomain).find_by_id!(params[:id]) if params[:id])
  end
end
