source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'

gem 'pg'
gem 'puma', '~> 3.0'

gem 'nokogiri'

gem 'sinatra', require: false
gem 'sidekiq'

# Bootstrap
gem 'twitter-bootstrap-rails'
gem 'bootstrap-sass', '~> 3.3.6'

# HTML/CSS
gem 'slim-rails'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'

gem 'kaminari' # pagination

gem 'active_model_serializers', github: 'rails-api/active_model_serializers'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# deploy
gem 'mina'