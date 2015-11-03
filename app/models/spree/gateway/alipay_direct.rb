module Spree
  class Gateway::AlipayDirect < Gateway::AlipayDualfun
    def service
      service_enum.create_direct_pay_by_user
    end
  end
end
