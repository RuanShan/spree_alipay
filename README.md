spree_alipay
============

Alipay, Tenpay and more chinese billing integration for Spree

for alipay, only support 双功能收款 和 即时到账收款。

dependency
----------
  activemerchant
  activemerchant_patch_for_china

Testing
-------
manual test

  cd spec/dummy
  rake db:reset
  rake spree_sample:load   # spree_sample/db/sample/* and spree_alipay/db/sample/* should be loaded both.
                           # task spree_sample:load is enhanced by spree_alipay/lib/tasks/sample.rake


Reference
---------
支付宝常见问题目录与索引——有助于您的问题能够快速解决

http://club.alipay.com/read.php?tid=8681712&fid=703#url_6

https://github.com/Shopify/active_merchant/wiki/Contributing