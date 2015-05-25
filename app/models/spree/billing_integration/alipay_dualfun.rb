
module Spree
    # use NewAlipay instead of BillingIntegration::Alipay
    # original name would cause 'toplevel constant Alipay referenced', since we are using https://github.com/chloerei/alipay
    class BillingIntegration::AlipayDualfun < BillingIntegration::AlipayBase
      preference :partner, :string
      preference :sign, :string
      #preference :email, :string
      #trade_create_by_buyer 
      #attr_accessible :preferred_server, :preferred_test_mode, :preferred_email, :preferred_partner, :preferred_sign
       
      def provider_class
        Spree::BillingIntegration::AlipayProvider
      end
  
      def provider
        provider_class.new( partner: preferred_partner, sign: preferred_sign, service: self.service )
      end
      
      def service
        service_enum.trade_create_by_buyer
      end
      # disable source for now
      def source_required?
        true
      end
      
      # payment source is required for processing
      def payment_source_class
        AlipayTransaction
      end
      
      def auto_capture?
        # 对于担保交易， 保存支付状态在alipay_transaction中
        return true
      end
      
      def authorize(amount, source, gateway_options)
        ActiveMerchant::Billing::Response.new(true, 'Alipay:success', {})
      end
      
      def capture(money, source, options = {})
        ActiveMerchant::Billing::Response.new(true, 'Alipay:success', {})
      end
  
      def purchase(money, source, options = {})
        ActiveMerchant::Billing::Response.new(true, 'Alipay:success', {})
      end
  
    end
  
end