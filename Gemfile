#source 'http://rubygems.org'
source 'http://ruby.taobao.org/'



gem 'ruby-hmac' #http://ryanbigg.com/2009/07/no-such-file-to-load-hmac-sha1/

gem 'activemerchant', :require => 'active_merchant'
#https://github.com/flyerhzm/activemerchant_patch_for_china/commit/9a1c46314661f527f24dd6a9d6b8be452f2f82b9
gem 'activemerchant_patch_for_china', '0.2.0' #support china billing_integration

gem 'alipay', '~> 0.1.0' # better payment_method class

# Provides basic authentication functionality for testing parts of your engine
group :development do
  gem 'spree_auth_devise', github: 'spree/spree_auth_devise', branch: '2-0-stable'
end
gemspec
