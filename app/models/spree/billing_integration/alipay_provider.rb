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
    
    def send_goods_confirm( alipay_transaction )
      options = {  :trade_no  => alipay_transaction.trade_no,
        :logistics_name => 'dalianshops.com',
        :transport_type => 'EXPRESS'
      }
      if trade_create_by_buyer?         
        alipay_return = ::Alipay::Service.send_goods_confirm_by_platform(options)
        alipay_xml_return = AlipayXmlReturn.new( alipay_return )
        if alipay_xml_return.success?
          alipay_transaction.update_attributes( :trade_status => alipay_xml_return.trade_status )
        end        
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