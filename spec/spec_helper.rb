require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'spec'
require 'spec/interop/test'
# set test environment
Sinatra::Base.set :environment, :test
Sinatra::Base.set :run, false
Sinatra::Base.set :raise_errors, true
Sinatra::Base.set :logging, false

require 'application'

Spec::Runner.configure do |config|
  # config.before(:each) { } 
end
