# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # def rackviz(options)
  #   src = controller.instance_eval { "http://localhost:9393/graph.png?dot=#{RedRaw.encode_url64(Zlib::Deflate.deflate(render_to_string(options)))}" }
  #   content_tag(:a, content_tag(:div, tag(:img, :src => src), :class => 'graph'), :href => src)
  # end

  def focus_form
    content_tag(:script, """
    //<![CDATA[
      scripts = document.getElementsByTagName('script');
      script = scripts[scripts.length - 1];
      Array.filter(script.parentElement.elements, function(e) {return e.getProperty('type') != 'hidden'}).pick().focus();
    //]]>
    """,
    :type => 'text/javascript')
  end
  
  def title(title)
    @title = title
  end

  def by_map(stakes)
    ActiveSupport::OrderedHash.new.tap do |output|
      stakes.each do |stake|
        (output[stake.map] ||= []) << stake
      end
    end
  end

  def map_events(events)
    ActiveSupport::OrderedHash.new.tap do |output|
      events.each do |event|
        (output[event.updated_at.to_date] ||= []) << event
      end
    end
  end
  
  def polymorphic_parameters(parent_node)
    {:parent_node_type => parent_node.class.to_s.underscore.pluralize, :parent_node_id => parent_node.id}
  end

  def linked_user_name(user)
    content_tag(:nobr, link_to(user.name, polymorphic_path(user), :class => 'user_name'))
  end

  def current_model_name
    controller_name.singularize.camelize
  end

  def controls_for(object)
    if write_permission?
      content_tag(
        :ul,
        [
          edit_control(object),
          delete_control(object)
        ].join,
        :class => 'controls'
      )
    end
  end

  def delete_control(object)
    content_tag(:li, link_to('delete', object, :confirm => 'Are you sure?', :method => :delete), :class => 'delete')
  end
  
  def edit_control(object)
    content_tag(:li, link_to('edit', polymorphic_path(object, :action => :edit)), :class => 'edit')
  end
  
  def new_link(text, hierarchy, link_options = {})
    link_to text, new_polymorphic_path(hierarchy, link_options), :class => 'button'
  end
  
  def trim_operator(operator)
    operator.slice(0, 1)
  end
  
  def status_image(object, params = {})
    status = Status::Enum[object.respond_to?(:computed_status) ? object.computed_status : object].to_s.downcase
    params[:title] ||= status.titlecase
    title = params.delete(:title)
    status = "#{status}_hollow" if object.instance_of?(Goal) and !object.propagate
    output = []
    output << image_tag("status/#{status}.png", params.reverse_merge(:title => title, :alt => title, :height => 20, :width => 20))
    if object.respond_to?(:propagate) and object.propagate
      output << image_tag("propagate.png", :class => 'propagate', :title => t('goals.propagate'), :alt => t('goals.propagate'))
    end
    content_tag(:div, output.join, :class => 'status_image')
  end
  
  def comment_status_image(object, params = {})
    status = (Status::Enum[object.respond_to?(:status) ? object.status : object] || 'none').to_s.downcase
    params[:title] ||= status.titlecase
    title = params.delete(:title)
    # status = "#{status}_hollow" if object.instance_of?(Comment) and !object.override_status
    image_tag("status/#{status}.png", params.reverse_merge(:title => title, :alt => title, :height => 20, :width => 20))
  end
  
  def status_tag(status)
    if status = Status::Enum[status].to_s
      content_tag(:span, status, :class => status.downcase)
    end
  end

  def breadcrumb(object)
    info = []
    info << status_image(object) if object.respond_to?(:status)
    info << content_tag(:span, [content_tag(:span, object.class.human_name, :class => 'model'), object.new_record?? %(New #{object.class.human_name}) : object.name].join)
    content_tag(:div, info.join(' '), :class => 'breadcrumb')
  end

  def breadcrumbs(object, result = [])
    if object
      breadcrumbs(object.parent_node, result) if object.respond_to?(:parent_node) and object.parent_node
      if object.respond_to?(:name) and object.respond_to?(:hierarchy)
        if resource == object
          result << content_tag(:li, link_to(breadcrumb(object), request.request_uri), :class => 'current_node')
        else
          result << content_tag(:li, link_to(breadcrumb(object), object.hierarchy))
        end
      end
    end
    result
  end

end
