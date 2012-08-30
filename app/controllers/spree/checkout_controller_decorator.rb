module Spree
  CheckoutController.class_eval do
    PAYMENT_METHODS = [:alipay_notify, :alipay_done]#, :tenpay_notify, :tenpay_done
    before_filter :alipay_checkout_hook, :only => [:update]
    skip_before_filter :load_order, only: PAYMENT_METHODS

    #https://github.com/flyerhzm/donatecn
    #demo for activemerchant_patch_for_china
    def alipay_checkout_payment
       #@payment_method =  PaymentMethod.find(params[:payment_method_id])
       #Rails.logger.debug "@payment_method=#{@payment_method.inspect}"       
       load_order
       #redirect_to_alipay_gateway(:subject => "donatecn", :body => "donatecn", :amount => @donate.amount, :out_trade_no => "123", :notify_url => pay_fu.alipay_transactions_notify_url)

    end

    def alipay_done
      payment_return = ActiveMerchant::Billing::Integrations::Alipay::Return.new(request.query_string)
      #TODO check payment_return.success
      retrieve_order(payment_return.order)
Rails.logger.debug "payment_return=#{payment_return.inspect}"
      if @order.present?
        @order.payment.complete!
        @order.state='complete'
        @order.finalize!
        session[:order_id] = nil
        redirect_to completion_route
      else
        #Strange, Failed trying to complete pending payment!
        redirect_to edit_order_checkout_url(@order, :state => "payment")
      end
    end
    
    def alipay_notify
      notification = ActiveMerchant::Billing::Integrations::Alipay::Notification.new(request.raw_post)
      retrieve_order(notification.out_trade_no)
      if @order.present? and notification.acknowledge() and valid_alipay_notification?(notification,@order.payment.payment_method.preferred_partner)
        if notification.complete?
          @order.payment.complete!
        else
          @order.payment.failure!
        end
        render text: "success" 
      else
        render text: "fail" 
      end
      
    end
    
    private

    def alipay_checkout_hook
      return unless (params[:state] == "payment")
      return unless params[:order][:payments_attributes]
     
      if @order.update_attributes(object_params) #it would create payments
        if params[:order][:coupon_code] and !params[:order][:coupon_code].blank? and @order.coupon_code.present?
          fire_event('spree.checkout.coupon_code_added', :coupon_code => @order.coupon_code)
        end
      end
     
     payment_method = PaymentMethod.find(params[:order][:payments_attributes].first[:payment_method_id])
     if payment_method.kind_of?(BillingIntegration::Alipay)
      
       # set_alipay_constant_if_needed 
       # ActiveMerchant::Billing::Integrations::Alipay::KEY
       # ActiveMerchant::Billing::Integrations::Alipay::ACCOUNT
       # gem activemerchant_patch_for_china is using it.
       # should not set when payment_method is updated, after restart server, it would be nil
       # TODO fork the activemerchant_patch_for_china, change constant to class variable
       alipay_klass = ActiveMerchant::Billing::Integrations::Alipay::Helper
       alipay_klass.send(:remove_const, :KEY) if alipay_klass.const_defined?(:KEY)
       alipay_klass.const_set(:KEY, payment_method.preferred_sign)
      
       load_order
       redirect_to(alipay_checkout_payment_order_checkout_url(@order, :payment_method_id => payment_method.id))
     end
    end
    
    def retrieve_order(order_number)
        @order = Spree::Order.find_by_number(order_number)
        if @order
          @order.payment.try(:payment_method).try(:provider) #configures ActiveMerchant
        end
    end
    
    def valid_alipay_notification?(notification, account)
      url = "https://www.alipay.com/cooperate/gateway.do?service=notify_verify"
      result = HTTParty.get(url, query: {partner: account, notify_id: notification.notify_id}).body
      result == 'true'
    end

  end
end
