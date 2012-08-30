module Spree
  class BillingIntegration::Alipay < BillingIntegration
    preference :partner, :string
    preference :sign, :string
    attr_accessible :preferred_server, :preferred_test_mode, :preferred_partner, :preferred_sign 
   
    def provider_class
      ActiveMerchant::Billing::Integrations::Alipay
    end
  end
end