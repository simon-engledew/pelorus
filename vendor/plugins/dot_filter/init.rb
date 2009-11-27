require 'zlib'
require 'red_raw'

module Haml::Filters::Rackviz
  include Haml::Filters::Base

  # def compile(precompiler, text)
  #   #src = ::ERB.new(text).src.sub(/^#coding:.*?\n/, '').sub(/^_erbout = '';/, "").gsub("\n", ';')
  #   #raise src.to_s
  #   #precompiler.send(:push_silent, "_hamlout RedRaw.encode_url64(Zlib::Deflate.deflate('hello'));")
  #   precompiler.instance_eval do
  #     push_silent(::ERB.new(text).src.sub(/^#coding:.*?\n/, '').sub(/^_erbout = '';/, "").gsub("\n", ';'))
  #     push_silent("output = RedRaw.encode_url64(Zlib::Deflate.deflate(_erbout))")
  #     push_script("tag(:img, :src => 'http://localhost:9393/graph.png?dot=' + output)")
  #   end
  # end
  
  # def render(text)
  #   text = ::ERB.new(text).result
  #   %(<img src="http://localhost:9393/graph.png?dot=#{RedRaw.encode_url64(Zlib::Deflate.deflate(text))}" />)
  # end
end