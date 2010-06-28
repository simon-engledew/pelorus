# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # def rackviz(options)
  #   src = controller.instance_eval { "http://localhost:9393/graph.png?dot=#{RedRaw.encode_url64(Zlib::Deflate.deflate(render_to_string(options)))}" }
  #   content_tag(:a, content_tag(:div, tag(:img, :src => src), :class => 'graph'), :href => src)
  # end
  
  def polymorphic_parameters(parent_node)
    {:parent_node_type => parent_node.class.to_s.underscore.pluralize, :parent_node_id => parent_node.id}
  end

  def linked_user_name(user)
    content_tag(:nobr, link_to(user.name, polymorphic_path(user), :class => 'user_name'))
  end

  def current_model_name
    controller_name.singularize.camelize
  end

  def delete_link(object)
    write_permission? ? content_tag(:div, link_to(content_tag(:span, 'Delete'), object, :confirm => 'Are you sure?', :method => :delete), :class => 'control delete') : nil
  end
  
  def edit_link(object)
    write_permission? ? content_tag(:div, link_to(content_tag(:span, 'Edit'), [:edit, *object]), :class => 'control edit') : nil
  end
  
  def new_link(text, hierarchy, link_options = {})
    link_to text, polymorphic_path(hierarchy, link_options.reverse_merge(:action => :new)), :class => 'button'
  end
  
  def trim_operator(operator)
    operator.slice(0, 1)
  end
  
  def status_image(object, title = nil)
    status = Status::Enum[object.respond_to?(:status) ? object.status : object].to_s.downcase
    title ||= status.titlecase
    status = "#{status}_hollow" if object.instance_of?(Goal) and !object.propagate
    image_tag("status/#{status}.png", :title => title, :alt => title, :height => 20, :width => 20)
  end
  
  def status_tag(status)
    if status = Status::Enum[status].to_s
      content_tag(:span, status, :class => status.downcase)
    end
  end

  def breadcrumb(object)
    info = []
    info << status_image(object) if object.respond_to?(:status)
    info << content_tag(:span, "&lt;#{object.class.to_s.singularize.humanize}&gt; #{object.name}")
    content_tag(:div, info.join(' '), :class => 'breadcrumb')
  end

  def breadcrumbs(object, result = [])
    if object
      breadcrumbs(object.parent_node, result) if object.respond_to?(:parent_node) and object.parent_node
      if object.respond_to?(:name) and object.respond_to?(:hierarchy) and object.id
        result << content_tag(:li, link_to(breadcrumb(object), object.hierarchy), :class => resource == object ? 'current_node' : nil)
      end
    end
    result
  end

end
