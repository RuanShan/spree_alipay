module Spree
  class Gateway::AlipayEscrow < Gateway::AlipayDualfun

    def service
      ServiceEnum.create_partner_trade_by_buyer
    end

    def auto_capture?
      return false
    end

  end
end
