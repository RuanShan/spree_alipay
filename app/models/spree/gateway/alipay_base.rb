module Spree
    # start from Spree 3.0, class Gateway is removed
    class Gateway::AlipayBase < PaymentMethod
      cattr_accessor :service_enum
      self.service_enum = Struct.new(:trade_create_by_buyer, :create_direct_pay_by_user)['trade_create_by_buyer', 'create_direct_pay_by_user']
  
      def service
        raise 'You must implement service method for alipay service'
      end
  
    end
  
end
