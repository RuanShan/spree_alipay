
module Spree
  # use NewAlipay instead of BillingIntegration::Alipay
  # original name would cause 'toplevel constant Alipay referenced', since we are using https://github.com/chloerei/alipay
  class BillingIntegration::AlipayDualfun < BillingIntegration::AlipayBase
    preference :partner, :string
    preference :sign, :string
    preference :email, :string
    #trade_create_by_buyer 
    attr_accessible :preferred_server, :preferred_test_mode, :preferred_email, :preferred_partner, :preferred_sign
     
    def provider_class
      Spree::BillingIntegration::AlipayProvider
    end

    def provider
      provider_class.new( partner: preferred_partner, sign: preferred_sign, email: preferred_email, service: self.service )
    end
    
    def service
      service_enum.trade_create_by_buyer
    end
    # disable source for now
    def source_required?
      false
    end
    
    # payment source is required for processing
    def payment_source_class
      AlipayTransaction
    end
    
    def auto_capture?
      # 对于 trade_create_by_buyer 标准双接口
      # payment_method 不知道用户选择担保交易或者即时到账交易
      # 在 alipay_done 中，根据用户支付类型，决定是否调用 capture
      return false
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