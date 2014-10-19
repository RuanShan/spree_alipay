Spree::Payment.class_eval do
  def method_alipay?
    payment_method.kind_of? Spree::BillingIntegration::AlipayBase
  end  
end