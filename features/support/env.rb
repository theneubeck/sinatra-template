require File.expand_path(File.dirname(__FILE__)+'/../../spec/spec_helper')
require 'haml'
require 'spec/expectations'
require 'rack/test'
require 'webrat'
require 'cucumber/formatter/unicode'
require 'cucumber/web/tableish'
require 'webrat/core/matchers'


Webrat.configure do |config|
  config.mode = :rack
end

World do
  def app
    @app = Rack::Builder.new do
      run MainApp
    end
  end
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers
  # Webrat::SinatraSession.new
end
