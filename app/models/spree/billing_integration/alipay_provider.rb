module Spree
  class BillingIntegration::AlipayProvider
    attr_accessor :service
    def initialize( options = {})
      ::Alipay.pid = options[:partner]
      ::Alipay.key = options[:sign]
      ::Alipay.seller_email = options[:email]
      self.service =  options[:service]
    end  
    
    def verify?( notify_params )
      ::Alipay::Notify.verify?(notify_params)
    end  
    
    def url( options )
      if trade_create_by_buyer?
        ::Alipay::Service.trade_create_by_buyer_url( options )
      end
    end
    
    # 标准双接口
    def trade_create_by_buyer?
      self.service == 'trade_create_by_buyer'
    end
    
    # 即时到帐
    def create_direct_pay_by_user?
      self.service == 'create_direct_pay_by_user'      
    end
    
    # 担保交易
    def create_partner_trade_by_buyer?
      self.service == 'create_partner_trade_by_buyer'      
    end
  end
end