#inspired by https://github.com/spree-contrib/spree_skrill
module Spree
  class AlipayStatusController < StoreController
      
    def alipay_done
      payment_return = ActiveMerchant::Billing::Integrations::Alipay::Return.new(request.query_string)
      #TODO check payment_return.success
      order = retrieve_order(payment_return.order)
      # 担 保交易的交易状态变更顺序依次是:
      #  WAIT_BUYER_PAY→WAIT_SELLER_SEND_GOODS→WAIT_BUYER_CONFIRM_GOODS→TRADE_FINISHED。
      # 即时到账的交易状态变更顺序依次是:
      #  WAIT_BUYER_PAY→TRADE_FINISHED。
      # payment.state always :complete for both service, payment.source store more detail
      alipay_transaction = AlipayTransaction.create_from_postback payment_return.params     
      payment = order.pending_payments.last
      payment.source = alipay_transaction
      payment.save!
      # it require pending_payments to process_payments!
      order.next
      if order.complete?
        #copy from spree/frontend/checkout_controller
        session[:order_id] = nil
        flash.notice = Spree.t(:order_processed_successfully)
        flash[:commerce_tracking] = "nothing special"
        redirect_to spree.order_path( order )
      else
        #Strange
        redirect_to checkout_state_path(order.state)
      end
    end

    def alipay_notify
      notification = ActiveMerchant::Billing::Integrations::Alipay::Notification.new(request.raw_post)
      order = retrieve_order(notification.out_trade_no)
      if order.present? and notification.acknowledge() and valid_alipay_notification?(notification,@order.payments.first.payment_method.preferred_partner)
        if notification.complete?
          order.payments.first.complete!
        else
          order.payments.first.failure!
        end
        render text: "success" 
      else
        render text: "fail" 
      end

    end

    private

    def retrieve_order(order_number)
      @order = Spree::Order.find_by_number!(order_number)
    end    

    def valid_alipay_notification?(notification, account)
      url = "https://mapi.alipay.com/gateway.do?sey"
      result = HTTParty.get(url, query: {partner: account, notify_id: notification.notify_id}).body
      result == 'true'
    end
       
  end
end
