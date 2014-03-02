#encoding: utf-8
module Spree
  CheckoutController.class_eval do
    cattr_accessor :skip_payment_methods
    self.skip_payment_methods = [:alipay_notify, :alipay_done]#, :tenpay_notify, :tenpay_done
    before_filter :checkout_hook, :only => [:update]
    #invoid WARNING: Can't verify CSRF token authenticity
    skip_before_filter :verify_authenticity_token, :only => self.skip_payment_methods
    # these two filters is from spree_auth_devise
    skip_before_filter :check_registration, :check_authorization, :only=> self.skip_payment_methods

    def alipay_done
      payment_return = ActiveMerchant::Billing::Integrations::Alipay::Return.new(request.query_string)
      #TODO check payment_return.success
      retrieve_order(payment_return.order)
#      Rails.logger.info "payment_return=#{payment_return.inspect}"
      if @order.present?
        @order.payments.where(:state => ['processing', 'pending', 'checkout']).first.complete!
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
      if @order.present? and notification.acknowledge() and valid_alipay_notification?(notification,@order.payments.first.payment_method.preferred_partner)
        if notification.complete?
          @order.payment.first.complete!
        else
          @order.payment.first.failure!
        end
        render text: "success" 
      else
        render text: "fail" 
      end

    end

    #https://github.com/flyerhzm/donatecn
    #demo for activemerchant_patch_for_china
    #since alipay_full_service_url is working, it is only for debug for now.
    def alipay_checkout_payment
      payment_method =  PaymentMethod.find(params[:payment_method_id])
      #Rails.logger.debug "@payment_method=#{@payment_method.inspect}"       
      Rails.logger.debug "alipay_full_service_url:"+aplipay_full_service_url(@order, payment_method)
      # notice that load_order would call before_payment, if 'http==put' and 'order.state == payment', the payments will be deleted. 
      # so we have to create payment again
      @order.payments.create(:amount => @order.total, :payment_method_id => payment_method.id)
      #redirect_to_alipay_gateway(:subject => "donatecn", :body => "donatecn", :amount => @donate.amount, :out_trade_no => "123", :notify_url => pay_fu.alipay_transactions_notify_url)
    end

    private
    
    def load_order_with_lock_with_alipay_return      
      if request.referer=~/alipay.com/
        payment_return = ActiveMerchant::Billing::Integrations::Alipay::Return.new(request.query_string)
        @current_order = retrieve_order(payment_return.order)                  
      end      
      load_order_with_lock_without_alipay_return
    end
    
    #because of PR below, load_order is renamed to load_order_with_lock
    #https://github.com/spree/spree/commit/45eabed81e444af3ff1cf49891f64c85fdd8d546
    alias_method_chain :load_order_with_lock, :alipay_return
     
    def checkout_hook
      #logger.debug "----before checkout_hook"    
      #all_filters = self.class._process_action_callbacks
      #all_filters = all_filters.select{|f| f.kind == :before}
      #logger.debug "all before filers:"+all_filters.map(&:filter).inspect 
      #TODO support step confirmation 
Rails.logger.debug "--->checkout_hooking?"
      return unless @order.next_step_complete?
      return unless params[:order][:payments_attributes].present?
Rails.logger.debug "--->before update_attributes"
      if @order.update_attributes(object_params) #it would create payments
        if params[:order][:coupon_code] and !params[:order][:coupon_code].blank? and @order.coupon_code.present?
          fire_event('spree.checkout.coupon_code_added', :coupon_code => @order.coupon_code)
        end
      end
      if pay_by_billing_integration?
Rails.logger.debug "--->before handle_billing_integration"
        handle_billing_integration
      end
    end

    def retrieve_order(order_number)
      @order = Spree::Order.find_by_number(order_number)
      if @order
        #@order.payment.try(:payment_method).try(:provider) #configures ActiveMerchant
      end
      @order
    end

    def valid_alipay_notification?(notification, account)
      url = "https://mapi.alipay.com/gateway.do?service=notify_verify"
      result = HTTParty.get(url, query: {partner: account, notify_id: notification.notify_id}).body
      result == 'true'
    end


    def aplipay_full_service_url( order, alipay)
      raise ArgumentError, 'require Spree::BillingIntegration::Alipay' unless alipay.is_a? Spree::BillingIntegration::Alipay
      url = ActiveMerchant::Billing::Integrations::Alipay.service_url+'?'
      helper = ActiveMerchant::Billing::Integrations::Alipay::Helper.new(order.number, alipay.preferred_partner)
      using_direct_pay_service = alipay.preferred_using_direct_pay_service

      if using_direct_pay_service
        helper.total_fee order.total
        helper.service ActiveMerchant::Billing::Integrations::Alipay::Helper::CREATE_DIRECT_PAY_BY_USER
      else
        helper.price order.item_total
        helper.quantity 1
        helper.logistics :type=> 'EXPRESS', :fee=>order.adjustment_total, :payment=>'BUYER_PAY' 
        helper.service ActiveMerchant::Billing::Integrations::Alipay::Helper::TRADE_CREATE_BY_BUYER
      end
      helper.seller :email => alipay.preferred_email
      #url_for is controller instance method, so we have to keep this method in controller instead of model
      helper.notify_url url_for(:only_path => false, :action => 'alipay_notify')
      helper.return_url url_for(:only_path => false, :action => 'alipay_done')
      helper.body order.products.collect(&:name).to_s #String(400) 
      helper.charset "utf-8"
      helper.payment_type 1
      helper.subject "订单编号:#{order.number}"
      helper.sign
      url << helper.form_fields.collect{ |field, value| "#{field}=#{value}" }.join('&')
      URI.encode url # or URI::InvalidURIError    
    end

    def pay_by_billing_integration?
      if @order.next_step_complete?
        if @order.pending_payments.first.payment_method.kind_of? BillingIntegration 
          return true
        end
      end
      return false
    end
    
    # handle all supported billing_integration
    def handle_billing_integration      
      payment_method = @order.pending_payments.first.payment_method
      if payment_method.kind_of?(BillingIntegration::Alipay)
        # set_alipay_constant_if_needed 
        # ActiveMerchant::Billing::Integrations::Alipay::KEY
        # ActiveMerchant::Billing::Integrations::Alipay::ACCOUNT
        # gem activemerchant_patch_for_china is using it.
        # should not set when payment_method is updated, after restart server, it would be nil
        # TODO fork the activemerchant_patch_for_china, change constant to class variable
        alipay_helper_klass = ActiveMerchant::Billing::Integrations::Alipay::Helper
        alipay_helper_klass.send(:remove_const, :KEY) if alipay_helper_klass.const_defined?(:KEY)
        alipay_helper_klass.const_set(:KEY, payment_method.preferred_sign)

        #redirect_to(alipay_checkout_payment_order_checkout_url(@order, :payment_method_id => payment_method.id))
        redirect_to aplipay_full_service_url(@order, payment_method)
      end
    end
    
    #patch spree_auth_devise/checkout_controller_decorator
    def skip_state_validation?
      %w(registration update_registration).include?(params[:state])
    end
  end
end
