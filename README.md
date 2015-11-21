spree_alipay
============

Alipay for Spree

Now support 双功能收款 , 即时到账收款 和 担保交易收款。

Sample
---------
1. 2-0-stable http://spree-alipay-sample.herokuapp.com
2. 2-2-stable http://spree-alipay-sample-220.herokuapp.com

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

Dependency
----------
  gem spree  https://www.github.com/spree/spree

  gem alipay https://www.github.com/chloerei/alipay

Notes
----------
  For Alipay 担保交易收款 "Escrow Account", use Spree::Gateway::AlipayEscrow
  this will redirect you to https://b.alipay.com/order/productDetail.htm?productId=2015110218011847


  For Alipay 双功能收款 和 即时到账收, use Spree::Gateway::AlipayDirect, this
  will redirect you to https://b.alipay.com/order/productDetail.htm?productId=2015110218012942

Testing
-------
1. test
```ruby
  bundle exec rake test_app
  rspec spec/feature/alipay_spec.rb
```
2. manual test
```ruby
  cd spec/dummy
  rake db:reset
  rake spree_sample:load
```  
Reference
---------
支付宝常见问题目录与索引——有助于您的问题能够快速解决

  [Alipay Official Doc]( http://doc.open.alipay.com/doc2/alipayDocIndex.htm "Alipay Doc")
