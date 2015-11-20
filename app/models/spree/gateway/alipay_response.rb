module Spree
  class Gateway::AlipayResponse
   attr_accessor :authorization

    def success?
      true
    end
  end
end
