class LabellingFormBuilder < ActionView::Helpers::FormBuilder

  include ActionView::Helpers::TagHelper

  class_eval do
    instance_eval do
      [:select, :grouped_select, :text_field, :password_field, :text_area, :check_box, :file_field].each do |method_name|
        define_method(method_name) do |method, *args|
          hash = args.last.is_a?(Hash)? args.last : {}
          errors = @object.errors.on(method)

          label_text = []
          label_text << (hash.delete(:label) || human_attribute_name(method))
          (label_text << content_tag(:span, [*errors].last, :class => 'error')) unless errors.blank?

          output  = []
          output << label(method, label_text.join(' '))
          output << super(method, *args)
          content_tag(:div, output.join(' '), :class => 'input')
        end
      end
    end
  end

protected

  def full_message(attribute, message)
    human_attribute_name(attribute) + I18n.t('activerecord.errors.format.separator', :default => ' ') + message
  end

  def human_attribute_name(attribute)
    @object.class.human_attribute_name(attribute, :default => attribute.to_s.humanize)
  end

end