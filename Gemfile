source 'http://rubygems.org'

gem 'rails', '4.2.5'

# Bundle edge Rails instead:
#gem 'rails', :git => 'git://github.com/rails/rails.git'

group :assets do
  gem 'sass-rails'
  # gem 'coffee-rails', '~> 4.0.0' # XXX remove
  gem 'uglifier', '>= 1.3.0'
end

gem 'pg' # postgres
gem 'puma'

gem 'daemon_controller'
#gem 'therubyracer', platforms: :ruby
#gem 'react-rails', '~> 1.0' #, github: 'reactjs/react-rails'
gem 'jbuilder'
#gem "browserify-rails", "~> 0.7"
#gem 'momentjs-rails'

gem 'devise', '~> 3.4.1'
gem 'bluecloth'
gem 'paperclip', '~> 3.0'
gem 'money'
gem 'money-rails'
gem 'stringex'

gem "sass", :require => 'sass'
# gem "bower-rails", "~> 0.10.0"

# Deploy with Capistrano
gem 'capistrano', '~> 3.0', require: false, group: :development

group :development do
  gem 'capistrano-rails',   '~> 1.1', require: false
  gem 'capistrano-bundler', '~> 1.1', require: false
  gem 'capistrano-rbenv', '~> 2.0', require: false
  gem 'capistrano-npm', require: false
  gem 'capistrano3-puma'
  gem 'guard'
  gem 'guard-livereload'
  gem 'web-console', '~> 2.0'
end
