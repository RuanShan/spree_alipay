spree_alipay
============

Alipay, Tenpay and more chinese billing integration for Spree

for alipay, only support 双功能收款 和 即时到账收款。

Sample
---------
2-0-stable http://spree-alipay-sample.herokuapp.com
2-2-stable http://spree-alipay-sample-220.herokuapp.com

Installation
---------
1. Add the following to your applications Gemfile

  gem 'spree_alipay',   :github => "RuanShan/spree_alipay", :branch=>"2-0-stable"(or you perferred branch)

2. Run bundler

  bundle install

3. Copy and execute migrations:

  rails g spree_alipay:install
  
  rake railties:install:migrations #if you upgraded spree, run this command
  
  rake db:migrate
  
dependency
----------
  activemerchant
  activemerchant_patch_for_china


Testing
-------
  create dummy to test
  bundle exec rake test_app

  manual test
  # spree_sample/db/sample/* and spree_alipay/db/sample/* should be loaded both.   
  # task spree_sample:load is enhanced by spree_alipay/lib/tasks/sample.rake

  cd spec/dummy
  rake db:reset
  rake spree_sample:load


Reference
---------
支付宝常见问题目录与索引——有助于您的问题能够快速解决

http://club.alipay.com/read.php?tid=8681712&fid=703#url_6

https://github.com/Shopify/active_merchant/wiki/Contributing