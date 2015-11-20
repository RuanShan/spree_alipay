module Spree
  class Gateway::AlipayDirect < Gateway::AlipayDualfun
    def service
      service_enum.create_direct_pay_by_user
    end

    def auto_capture?
      return true
    end

  end
end
