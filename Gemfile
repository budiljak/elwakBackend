source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.0.1'

# Use sqlite3 as the database for Active Record
gem 'sqlite3', group: :development

group :production, :test do
  # Neuere Versionen (ab 0.4.x) funktionieren nicht mit Rails 4.0
  # (bundle install --without production test)
  # siehe auch initializers/mysql2_adapter.rb
  gem 'mysql2', '~> 0.3.21'
end

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 3.1.0'
gem 'jquery-ui-rails', '~> 5.0.3'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'carrierwave'

gem 'nokogiri'

gem 'prawn'
gem 'prawn-table'

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
gem 'capistrano', '~> 3.4.0', group: :development
gem 'capistrano-bundler', group: :development
gem 'capistrano-rails', group: :development
gem 'capistrano-rbenv', github: "capistrano/rbenv", group: :development
# gem 'capistrano-rvm', github: "capistrano/rvm", group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
