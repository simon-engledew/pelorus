class DotHandler < ActionView::TemplateHandler
  include ActionView::TemplateHandlers::Compilable
  def compile(path)
    <<-EOS
      controller.response.content_type ||= Mime::SVG
      
      #{ActionView::Template.handler_class_for_extension('erb').call(path)}
      
      $stdout.puts @output_buffer
      
      @output_buffer = IO.popen("dot -Tsvg", 'r+') do |io|
        io.write(@output_buffer)
        io.close_write
        io.set_encoding('BINARY') if io.respond_to?(:set_encoding)
        io.read
      end
    EOS
  end
  
end