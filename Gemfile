#source 'http://rubygems.org'
source 'http://ruby.taobao.org/'



gem 'ruby-hmac' #http://ryanbigg.com/2009/07/no-such-file-to-load-hmac-sha1/

group :test,:development do
  #https://github.com/spree/spree/issues/4442
  #gem 'sprockets', '2.11.0'
  # Provides basic authentication functionality for testing parts of your engine
  gem 'spree', github: 'spree/spree', branch: '3-0-stable'
  gem 'spree_auth_devise', github: 'spree/spree_auth_devise', branch: '3-0-stable'
end

gem 'alipay' # better payment_method class
gem 'offsite_payments'
gem 'activemerchant_patch_for_china', github:'RuanShan/activemerchant_patch_for_china', branch:'for_offsite_payments'
gemspec
