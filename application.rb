# encoding: utf-8
require 'rubygems'
require 'sinatra/base'
require 'environment'

# basic setup
class Sinatra::Base
  register SinatraMore::MarkupPlugin
  register SinatraMore::RenderPlugin

  use Rack::Session::Cookie
  use Rack::Flash, :sweep => true
  use Rack::MethodOverride
  
  # use Rack::Session::Cookie, :secret=>SECRET
  set :app_file, __FILE__
  set :root, File.dirname(__FILE__)
  set :static, true
  set :views, "#{File.dirname(__FILE__)}/views"
  set :public, Proc.new { File.join(File.dirname(__FILE__), 'public') }
  set :run, false

  
  def html_opts(hash)
    hash.map{|k,v| "#{k}=\"#{h(v)}\""}.join(' ')
  end
  
  helpers do
    include ViewHelpers
  end
  
  error do
    e = request.env['sinatra.error']
    Kernel.puts e.backtrace.join("\n")
    'Application error'
  end
    
end

# routing class

class MainApp < Sinatra::Base
  
  register PlugableRouter

  get "/" do
    "Hello World"
  end
  
end