module SpreeAlipay
  class Engine < Rails::Engine
    engine_name 'spree_alipay'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
    
    config.after_initialize do |app|
      require 'offsite_payments/action_view_helper'
      ActionView::Base.send(:include, OffsitePayments::ActionViewHelper)       
      app.config.spree.payment_methods += [
        Spree::BillingIntegration::AlipayDualfun
      ]
    end
  end
end
