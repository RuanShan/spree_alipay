Spree::Order.class_eval do
  def next_step_complete?
    available_steps = checkout_steps
    available_steps[ available_steps.index( self.state ).succ ] == 'complete'
  end
end
