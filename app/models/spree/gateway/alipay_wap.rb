module Spree
  class Gateway::AlipayWap < Gateway::AlipayDirect
    def service
      ServiceEnum.alipay_wap
    end

  end
end
