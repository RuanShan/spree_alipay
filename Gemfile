#source 'http://rubygems.org'
source 'http://ruby.taobao.org/'

gem 'rails', '3.2.8'
gem 'mysql2'

group :assets do
  gem 'sass-rails',   '~> 3.2.5'
  gem 'coffee-rails', '~> 3.2'
  gem 'uglifier', '>= 1.0.3'
end

group :test do
  gem 'ffaker'
end

if RUBY_VERSION < "1.9"
  gem "ruby-debug"
else
  gem "ruby-debug19"
end

gem 'jquery-rails'
gem 'spree', :github => "spree/spree", :branch => "1-2-stable"
# referer to https://github.com/spree/spree/issues/2013
gem 'spree_auth_devise', :github => "spree/spree_auth_devise", :branch => "1-2-stable"
gem 'activemerchant', :require => 'active_merchant'
gem 'activemerchant_patch_for_china' #support alipay

gemspec

