#inspired by https://github.com/spree-contrib/spree_skrill
module Spree
  class AlipayStatusController < StoreController
      
    def alipay_done
      # alipay acount could vary in each store. 
      # get order_no from query string -> get payment -> initialize Alipay -> verify ailpay callback
      order = retrieve_order params["out_trade_no"]      
      alipay_payment = get_alipay_payment( order )     
       
      if alipay_payment.payment_method.provider.verify?( request.query_parameters )
        # 担保交易的交易状态变更顺序依次是:
        #  WAIT_BUYER_PAY→WAIT_SELLER_SEND_GOODS→WAIT_BUYER_CONFIRM_GOODS→TRADE_FINISHED。
        # 即时到账的交易状态变更顺序依次是:
        #  WAIT_BUYER_PAY→TRADE_FINISHED。
        complete_order( order )
        if order.complete?
          #copy from spree/frontend/checkout_controller
          session[:order_id] = nil
          flash.notice = Spree.t(:order_processed_successfully)
          flash['order_completed'] = true
          redirect_to spree.order_path( order )
        else
          #Strange
          redirect_to checkout_state_path(order.state)
        end
      else
        redirect_to checkout_state_path(order.state)          
      end
    end

    def alipay_notify
      order = retrieve_order params["out_trade_no"]      
      alipay_payment = get_alipay_payment( order )     
      if alipay_payment.payment_method.provider.verify?( request.request_parameters )
        complete_order( order )
        render text: "success"
      else
        render text: "fail"         
      end
    end

    private

    def retrieve_order(order_number)
      @order = Spree::Order.find_by_number!(order_number)
    end    

    def get_alipay_payment( order )
      order.unprocessed_payments.last
    end
    
    def complete_order( order )
      unless order.complete?
        alipay_payment = get_alipay_payment( order )
        # payment.state always :complete for both service, payment.source store more detail
        alipay_transaction = AlipayTransaction.create_from_postback params     
        alipay_payment.source = alipay_transaction
        alipay_payment.save!
        # it require pending_payments to process_payments!
        order.next
      end
    end
       
  end
end