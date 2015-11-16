module Spree
  class Gateway::AlipayEscrow < Gateway::AlipayDualfun

    def service
      service_enum.create_partner_trade_by_buyer
    end
    
    def auto_capture?
      # 对于担保交易， 保存支付状态在alipay_transaction中
      return false
    end

  end
end
