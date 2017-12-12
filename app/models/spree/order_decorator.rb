Spree::Order.class_eval do
  register_update_hook :send_goods_confirm_for_alipay
  
  def next_step_complete?
    available_steps = checkout_steps
    available_steps[ available_steps.index( self.state ).succ ] == 'complete'
  end
  
  
  # it is update_hook for alipay, it is called when order.update!
  def send_goods_confirm_for_alipay
    #TODO consider partial shipped
    if shipped?
      payments_by_alipay = payments.completed.select(&:method_alipay?)
      
      if payments_by_alipay.present?
        payments_by_alipay.each{|pba|
          pba.source.send_goods_confirm
        }
      end
    end
  end
  
end
