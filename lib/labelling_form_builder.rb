class LabellingFormBuilder < ActionView::Helpers::FormBuilder

  include ActionView::Helpers::TagHelper
  
  def label(method, *args)
    errors = @object.errors.on(method.to_s.chomp('_id'))
    hash = args.last.is_a?(Hash)? args.last : {}
    text = []
    text << (hash.delete(:label) || human_attribute_name(method))
    text << content_tag(:span, [*errors].last, :class => 'error') unless errors.blank?
    super(method, text.join(' '))
  end

  def check_box_with_label(method, *args)
    output  = []
    output << label(method, *args)
    output << send(:check_box_without_label, method, *args)
    content_tag(:div, output.reverse.join(' '), :class => 'input check_box')
  end
  
  alias_method_chain :check_box, :label

  [:select, :text_field, :password_field, :text_area, :file_field].each do |method_name|
    define_method(:"#{method_name}_with_label") do |method, *args|
      output  = []
      output << label(method, *args)
      output << send(:"#{method_name}_without_label", method, *args)
      content_tag(:div, output.join(' '), :class => "input #{method_name}")
    end
    alias_method_chain method_name, :label
  end

protected

  def full_message(attribute, message)
    human_attribute_name(attribute) + I18n.t('activerecord.errors.format.separator', :default => ' ') + message
  end

  def human_attribute_name(attribute)
    @object.class.human_attribute_name(attribute, :default => attribute.to_s.humanize)
  end

end