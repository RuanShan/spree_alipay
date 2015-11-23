module Spree
    # start from Spree 3.0, class Gateway is removed
    class Gateway::AlipayBase < PaymentMethod
      preference :alipay_pid, :string
      preference :alipay_key, :string

      ServiceEnum = Struct.new( :trade_create_by_buyer,
        :create_direct_pay_by_user,
        :create_partner_trade_by_buyer,
        :alipay_wap)[ 'trade_create_by_buyer', 'create_direct_pay_by_user', 'create_partner_trade_by_buyer', 'alipay.wap.create.direct.pay.by.user']

      def service
        raise 'You must implement service method for alipay service'
      end
      
      def provider
        provider_class.new( partner: preferred_alipay_pid, sign: preferred_alipay_key, service: self.service )
      end

      # disable source for now
      def source_required?
        false
      end

    end

end
