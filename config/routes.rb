Spree::Core::Engine.add_routes do

  # Add your extension routes here
  get '/alipay_status/done/' => 'alipay_status#alipay_done', :as => :alipay_done
  post '/alipay_status/notify/' => 'alipay_status#alipay_notify', :as => :alipay_notify

  #fix issue
  #https://github.com/spree/spree_auth_devise/commit/bab2593f75909feeed3f53b54a63c2edd25f7ba5
  #get '/checkout/registration' => 'checkout#registration', :as => :checkout_registration
  #put '/checkout/registration' => 'checkout#update_registration', :as => :update_checkout_registration

  namespace :admin do
    # Using :only here so it doesn't redraw those routes
    resources :orders, :only => [] do
      resources :payments, :only => [] do
        member do
          get 'paypal_refund'
          post 'paypal_refund'
        end
      end
    end
  end


end

