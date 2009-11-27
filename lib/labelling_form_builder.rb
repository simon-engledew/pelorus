class LabellingFormBuilder < ActionView::Helpers::FormBuilder
  
  include ActionView::Helpers::TagHelper
  
  [:text_field, :password_field, :text_area, :select, :check_box].each do |input_method|
    define_method(input_method) do |*args|
      method, options = args[0], args[1]
      label = content_tag(:label, (options ? options.delete(:label) : nil) || "#{String(method).titlecase}")
      content_tag(:div, label + super(*args), :class => 'input')
    end
  end
  
end