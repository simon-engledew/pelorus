class DotHandler < ActionView::TemplateHandler
  include ActionView::TemplateHandlers::Compilable
  def compile(path)
    <<-EOS
      format ||= controller.params[:format]
      
      content_type = case format.to_s
        when 'svg' then Mime::SVG
        when 'png' then Mime::PNG
        when 'cmapx' then 'text/html'
        when 'dot' then 'text/plain'
        else raise "\#{format} not supported"
      end
      
      controller.response.content_type ||= content_type
      
      #{ ActionView::Template.handler_class_for_extension('erb').call(path) }
      
      unless format.to_s == 'dot'
        command = []
        command << "dot -T\#{format}"
        command << "2>/dev/null"
        command = command.join(' ')
  
        @output_buffer = IO.popen(command, 'r+') do |io|
          @output_buffer
          io.write(@output_buffer)
          io.close_write
          io.set_encoding('BINARY') if io.respond_to?(:set_encoding)
          io.read
        end
      end
      
      @output_buffer
    EOS
  end
  
end