ActionView::Helpers::AssetTagHelper.register_javascript_expansion :mootools => (Rails.env.production? || Rails.env.staging?) ?
  ['mootools/1.2/core-yc', 'mootools/1.2/more-yc'] :
  ['mootools/1.2/core', 'mootools/1.2/more']