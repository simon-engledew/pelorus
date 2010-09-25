Sass::Plugin.options[:template_location] = File.join('app', 'stylesheets')
Sass::Plugin.options[:style] = Rails.env.development?? :expanded : :compressed

module Sass::Script::Functions
  def numeric_value(pixels)
    assert_type pixels, :Number
    Sass::Script::String.new(pixels.coerce(['px'], []).value.to_s)
  end
end