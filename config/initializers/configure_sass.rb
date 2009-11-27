Sass::Plugin.options[:template_location] = File.join('app', 'stylesheets')
Sass::Plugin.options[:style] = Rails.env.production? ? :compressed : :expanded