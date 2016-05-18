source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'

# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc'

# Automatically prefix CSS attributes
gem 'autoprefixer-rails'

# Use Octicons
gem 'octicons-rails'

# Generate forms with Simple Form
gem 'simple_form'

# Use Devise for user authentication
gem 'devise'

# Generate a activity feed with Public Activity
gem 'public_activity'

# Use Pauma as the app server
gem 'puma'

# Automatically annotate models
gem 'annotate_models'

# Use Bootstrap Colorpicker for label colors
gem 'bootstrap_colorpicker_rails'

# Handle file attachments with Paperclip
#gem 'paperclip'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :production do
  # Use Postgres as production database.
  gem 'pg'
end


group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Do unit testing with RSpec
  gem 'rspec-rails'

  # Add HTML Matchers to RSpec
  gem 'rspec-html-matchers'

  # Add additional matchers to RSpec
  gem 'shoulda-matchers'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'

  # Spring speeds up development by keeping your application running in the background. Read more:
  # https://github.com/rails/spring
  gem 'spring'
end

group :test do
  # Use FactoryGirl for fixtures
  gem 'factory_girl_rails'

  # Generate random data with Faker
  gem 'faker'

  # Automatically run specs, when they're saved
  gem 'guard-rspec'

  # Display a notification when guard finishes
  gem 'terminal-notifier-guard'

  # Simulate user interaction via Capybara
  gem 'capybara'

  # Use WebKit as default webdriver
  gem 'poltergeist'

  # Clean the database via truncation, since poltergeist...
  gem 'database_cleaner'
end
