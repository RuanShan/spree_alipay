require 'alipay'

module Spree
  class Gateway::AlipayProvider
    attr_accessor :service

    def initialize( options = {})
      ::Alipay.pid = options[:partner]
      ::Alipay.key = options[:sign]
      #::Alipay.seller_email = options[:email]
      self.service =  options[:service]
    end

    def verify?( notify_params )
      ::Alipay::Notify.verify?(notify_params)
    end

    # * params
    #   * options - notify_url, return_url, body, subject
    def url( order, options = {} )
      pc_direct_params = {
        total_fee:  order.total
      }
      pc_escrow_params = {
        :price => order.item_total,
        :quantity => 1,
        :logistics_type=> 'EXPRESS',
        :logistics_fee => order.shipments.to_a.sum(&:cost),
        :logistics_payment=>'BUYER_PAY' }
      wap_params =  {
        total_fee:  order.total
        }

      case service
      when Gateway::AlipayBase::ServiceEnum.alipay_wap
        options.merge!( wap_params )
        ::Alipay::Service.create_direct_pay_by_user_wap_url( options )
      when Gateway::AlipayBase::ServiceEnum.create_direct_pay_by_user
        options.merge!( pc_direct_params )
        #create_direct_pay_by_user
        ::Alipay::Service.create_direct_pay_by_user_url( options )
      when Gateway::AlipayBase::ServiceEnum.create_partner_trade_by_buyer
        # escrow service
        options.merge!( pc_escrow_params )
        ::Alipay::Service.create_partner_trade_by_buyer_url( options )
      when Gateway::AlipayBase::ServiceEnum.trade_create_by_buyer
        options.merge!( pc_escrow_params )
        ::Alipay::Service.trade_create_by_buyer_url( options )
      end
    end

    def send_goods_confirm( alipay_transaction )
      options = {  :trade_no  => alipay_transaction.trade_no,
        :logistics_name => 'dalianshops.com',
        :transport_type => 'EXPRESS'
      }
      if trade_create_by_buyer? || create_partner_trade_by_buyer?
        alipay_return = ::Alipay::Service.send_goods_confirm_by_platform(options)
        alipay_xml_return = AlipayXmlReturn.new( alipay_return )
        if alipay_xml_return.success?
          alipay_transaction.update_attributes( :trade_status => alipay_xml_return.trade_status )
        end
      end
    end

    # 标准双接口
    def trade_create_by_buyer?
      self.service == Gateway::AlipayBase::ServiceEnum.trade_create_by_buyer
    end

    # 即时到帐
    def create_direct_pay_by_user?
      self.service == Gateway::AlipayBase::ServiceEnum.create_direct_pay_by_user
    end

    # 担保交易,  escrow
    def create_partner_trade_by_buyer?
      self.service == Gateway::AlipayBase::ServiceEnum.create_partner_trade_by_buyer
    end

    def alipay_wap?
      self.service == Gateway::AlipayBase::ServiceEnum.alipay_wap
    end


    # * description - before order transition to: :complete
    # *   call spree/payment#gateway_action
    # * params
    #   * options - gateway_options
    # * return - pingpp_response
    def purchase(money, credit_card, options = {})
      # since pingpp is offsite payment, this method is placehodler only.
      # in this way, we could go through spree payment process.
      return Gateway::AlipayResponse.new
    end

  end
end
