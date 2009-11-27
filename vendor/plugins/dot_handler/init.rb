require 'dot_handler'

ActionView::Template.register_template_handler 'dot', DotHandler
ActionView::Template.exempt_from_layout 'dot'