#source 'http://rubygems.org'
source 'https://ruby.taobao.org/'


group :test,:development do
  #https://github.com/spree/spree/issues/4442
  #gem 'sprockets', '2.11.0'
  # Provides basic authentication functionality for testing parts of your engine
  gem 'spree', github: 'spree/spree', branch: '3-1-stable'
  gem 'spree_auth_devise', github: 'spree/spree_auth_devise', branch: '3-1-stable'

end

group :development do
  gem "spring"
  gem 'pry-rails'
  gem 'byebug'
#  gem 'web-console', '~> 3.0'
#  gem 'capistrano'
#  gem 'capistrano-rails', '~> 1.1.0'
#  gem 'capistrano-rvm', '~> 0.1.0'
#  #gem "rails-erd"
end

gemspec
