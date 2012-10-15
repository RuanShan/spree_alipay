#encoding: utf-8
module Spree
  class BillingIntegration::Alipay < BillingIntegration
    preference :partner, :string
    preference :sign, :string
    preference :email, :string
    preference :using_direct_pay_service, :boolean, :default => true #CREATE_DIRECT_PAY_BY_USER
    attr_accessible :preferred_server, :preferred_test_mode, :preferred_email, :preferred_partner, :preferred_sign, :preferred_using_direct_pay_service
   
     
    def provider_class
      ActiveMerchant::Billing::Integrations::Alipay
    end
    
        
  end
end