module Spree
  class Gateway::AlipayEscrow < Gateway::AlipayDualfun

    def service
      service_enum.create_partner_trade_by_buyer
    end

    def auto_capture?
      return false
    end

  end
end
