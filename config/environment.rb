# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Misterbusinessfinance::Application.initialize!

#Logging
Rails.logger = Logger.new(STDOUT)
#Rails.logger = Log4r::Logger.new("Application Log")
