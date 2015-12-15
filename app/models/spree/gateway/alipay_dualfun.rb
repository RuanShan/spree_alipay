module Spree
    # use NewAlipay instead of BillingIntegration::Alipay
    # original name would cause 'toplevel constant Alipay referenced', since we are using https://github.com/chloerei/alipay
    class Gateway::AlipayDualfun < Gateway::AlipayBase
      #preference :email, :string
      #trade_create_by_buyer
      #attr_accessible :preferred_server, :preferred_test_mode, :preferred_email, :preferred_alipay_pid, :preferred_alipay_key

      def provider_class
        Spree::Gateway::AlipayProvider
      end


      def service
        ServiceEnum.trade_create_by_buyer
      end

      def auto_capture?
        #
        return false
      end

    end

end
