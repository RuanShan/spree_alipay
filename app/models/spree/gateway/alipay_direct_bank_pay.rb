module Spree
  class Gateway::AlipayDirectBankPay < Gateway::AlipayDirect

    def auto_capture?
      return true
    end

  end
end
