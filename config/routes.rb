Spree::Core::Engine.routes.prepend do
  resources :orders do
    resource :checkout, :controller => 'checkout' do
      member do
        get :alipay_checkout_payment
        get :alipay_done
        post :alipay_notify
      end
    end
  end

  # Add your extension routes here
  match '/alipay_checkout/done/' => 'checkout#alipay_done', :as => :alipay_done
  match '/alipay_checkout/notify/' => 'checkout#alipay_notify', :as => :alipay_notify

  #fix issue
  #https://github.com/spree/spree_auth_devise/commit/bab2593f75909feeed3f53b54a63c2edd25f7ba5
  get '/checkout/registration' => 'checkout#registration', :as => :checkout_registration
  put '/checkout/registration' => 'checkout#update_registration', :as => :update_checkout_registration

end

