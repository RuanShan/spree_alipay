#encoding: utf-8
module Spree
  CheckoutController.class_eval do
    before_filter :checkout_hook, :only => [:update]

    private
        
    def checkout_hook
      @alipay_base_class = Spree::BillingIntegration::AlipayBase
      @alipay_dualfun_class = Spree::BillingIntegration::AlipayDualfun
      #logger.debug "----before checkout_hook"    
      #all_filters = self.class._process_action_callbacks
      #all_filters = all_filters.select{|f| f.kind == :before}
      #logger.debug "all before filers:"+all_filters.map(&:filter).inspect 
      return unless @order.next_step_complete?
      #in confirm step, only param is  {"state"=>"confirm"}
      payment_method = get_payment_method(  )
      if payment_method.kind_of?( @alipay_base_class )
        handle_billing_integration
      end
    end

    def aplipay_full_service_url( order, alipay)
      
      #service partner _input_charset out_trade_no subject payment_type logistics_type logistics_fee logistics_payment seller_email price quantity
      options = { :_input_charset => "utf-8", 
                  :out_trade_no => order.number,
                  :price => order.item_total, 
                  :quantity => 1,
                  :logistics_type=> 'EXPRESS',
                  :logistics_fee=>order.adjustment_total, 
                  :logistics_payment=>'BUYER_PAY',
                  :seller_email => alipay.preferred_email,
                  :notify_url => url_for(:only_path => false, :controller=>'alipay_status', :action => 'alipay_notify'),
                  :return_url => url_for(:only_path => false, :controller=>'alipay_status', :action => 'alipay_done'),
                  :body => order.products.collect(&:name).to_s,  #String(400)                  
                  :payment_type => 1,
                  :subject =>"订单编号:#{order.number}"                  
         }
      alipay.provider.url( options )
    end
    
    # handle all supported billing_integration
    def handle_billing_integration      
      if @order.update_attributes(object_params)
        payment_method = get_payment_method(  )
        if payment_method.kind_of?(@alipay_base_class)
          
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
      else
        render( :edit ) and return        
      end
    end

    #in co@alipay_base_classis {"state"=>"confirm"}
    def get_payment_method(  )
      payment_method_id = params[:order].try(:[],:payments_attributes).try(:first).try(:[],:payment_method_id).to_i
      
      PaymentMethod.find_by_id(payment_method_id) || @order.pending_payments.first.try(:payment_method)     
    end
    
  end
end