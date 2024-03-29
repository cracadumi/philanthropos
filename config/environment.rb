# Load the Rails application.
require File.expand_path('../application', __FILE__)

# load local settings file
local_settings = File.join(Rails.root, 'config', 'local_settings.rb')
load(local_settings) if File.exists?(local_settings)
# Initialize the Rails application.
Rails.application.initialize!
