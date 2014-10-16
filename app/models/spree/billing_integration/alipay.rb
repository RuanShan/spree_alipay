module Spree
  class BillingIntegration::Alipay < BillingIntegration
    preference :partner, :string
    preference :sign, :string
    preference :email, :string
    preference :using_direct_pay_service, :boolean, :default => false #CREATE_DIRECT_PAY_BY_USER
    attr_accessible :preferred_server, :preferred_test_mode, :preferred_email, :preferred_partner, :preferred_sign, :preferred_using_direct_pay_service
   
     
    def provider_class
      ActiveMerchant::Billing::Integrations::Alipay
    end
    
    def authorize( money_in_cents, source, gateway_options )
      
    end  
    
      
    def purchase( money_in_cents, source, gateway_options )
      
    end    

    def capture( money_in_cents, source, gateway_options )
      
    end
    
  end
end