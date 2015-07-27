module Spree
  class AlipayTransaction < ActiveRecord::Base
    has_many :payments, :as => :source
    #attr_accessible :trade_no, :buyer_email, :trade_status, :total_fee, :refund_status, :payment_type
    def actions
      []
    end
    
    # * params - hash, string_key=>value
    def self.create_from_postback(params)
       create(:trade_no => params['trade_no'],
              :buyer_email => params['buyer_email'],
              :trade_status => params['trade_status'], #WAIT_SELLER_SEND_GOODS
              :total_fee=>params['total_fee'],
              :refund_status => params['refund_status'],
              :payment_type => params['payment_type'])
    end

    def send_goods_confirm(  )
      payment = payments.last
      payment_provider = payment.payment_method.provider
      payment_provider.send_goods_confirm( self )
    end
    

  end
end
