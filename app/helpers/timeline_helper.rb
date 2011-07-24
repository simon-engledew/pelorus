module TimelineHelper
  
  def event_model(model)
    model.destroyed?? model.name : link_to(model.name, polymorphic_path(model.hierarchy))
  rescue
    model.class
  end
  
end