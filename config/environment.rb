# Load the Rails application.
require File.expand_path('../application', __FILE__)

if defined?(Rails::Console)
  require 'hirb'
  Hirb.enable
end

# Initialize the Rails application.
EliminationCircle::Application.initialize!