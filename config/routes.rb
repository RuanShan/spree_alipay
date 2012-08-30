Spree::Core::Engine.routes.draw do

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
  # get '/alipay_checkout/done/' => 'checkout#alipay_done', :as => :alipay_done
  #  post '/alipay_checkout/done/' => 'checkout#alipay_done', :as => :alipay_done
end