# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
ElwakBackend::Application.initialize!

unless Rails.env.development?
  # Monkey patch problem with MySQL 5.7 (not allowing NULL for PRIMARY KEY)
  require File.expand_path('../initializers/mysql2_adapter', __FILE__)
end
