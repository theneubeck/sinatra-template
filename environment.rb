require 'rubygems'
require 'sqlite3'
require 'sequel'
require 'haml'
require 'ostruct'
require 'rack-flash'
require 'sinatra_more/markup_plugin'
require 'sinatra_more/render_plugin'
require 'cgi'

require 'sinatra/base' unless defined?(Sinatra)

class Sinatra::Base

  configure do
    ::SiteConfig = OpenStruct.new(
                   :title => 'Your Application Name',
                   :author => 'Your Name',
                   :url_base => 'http://localhost:4567/'
                 )

    ::DB = Sequel.connect("sqlite://#{File.expand_path(File.dirname(__FILE__))}/db/#{Sinatra::Base.environment}.db")

    # load helpers
    $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/helpers")
    Dir.glob("#{File.dirname(__FILE__)}/helpers/*.rb") { |l| require File.basename(l, '.*') }  

    # load models
    $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
    Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib| require File.basename(lib, '.*') }  
  end
end