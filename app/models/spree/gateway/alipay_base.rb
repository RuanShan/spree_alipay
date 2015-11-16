module Spree
    # start from Spree 3.0, class Gateway is removed
    class Gateway::AlipayBase < PaymentMethod
      # response_code -> trade_no:trade_status
      

      cattr_accessor :service_enum
      self.service_enum = Struct.new( :trade_create_by_buyer,
        :create_direct_pay_by_user,
        :create_partner_trade_by_buyer)[ 'trade_create_by_buyer', 'create_direct_pay_by_user', 'create_partner_trade_by_buyer']

      def service
        raise 'You must implement service method for alipay service'
      end

      # disable source for now
      def source_required?
        false
      end

    end

end
