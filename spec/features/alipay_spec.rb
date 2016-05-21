require 'spec_helper'
#copy from https://raw.github.com/radar/better_spree_paypal_express/master/spec/features/paypal_spec.rb
#http://sandbox.alipaydev.com/index.htm
#sandbox_areq22@aliyun.com
#http://openapi.alipaydev.com/gateway.do
describe "Alipay", :js => true, :type => :feature do
  include_context 'checkout setup'

  let( :alipay_config ) {
    {
      preferred_alipay_pid: ENV['ALIPAY_PID'],
      preferred_alipay_key: ENV['ALIPAY_KEY'],
      name: "Alipay",
      active: true,
    }
  }

  let!(:product) { FactoryGirl.create(:product, :name => 'iPad') }
  let(:country) { create(:country, name: 'United States of America', iso_name: 'UNITED STATES') }
  let(:state) { create(:state, name: 'Alabama', abbr: 'AL', country: country) }

  before do
    raise "plese set ALIPAY_KEY, ALIPAY_PID" unless  ENV['ALIPAY_PID'] && ENV['ALIPAY_KEY']
  end


#  context " service alipay_dualfun" do
#    before do
#      @gateway = Spree::Gateway::AlipayEscrow.create!( alipay_config )
#    end
#    it "pay an order successfully" do
#      #order[payments_attributes][][payment_method_id]
#      #order_payments_attributes__payment_method_id_1
#      payment_method_css = "order_payments_attributes__payment_method_id_#{@gateway.id}"
#      add_to_cart
#      fill_in_billing
#      click_button "Save and Continue"
#      # Delivery step doesn't require any action
#      click_button "Save and Continue"
#      # alipay is first and choosed
#      choose( payment_method_css) #payment_method_css
#      click_button "Save and Continue"
#      # should redirect to alipay casher page
#      expect(page).to have_selector('#orderContainer')
#      #page.should have_content( product.price.to_s )
#      #Spree::Payment.last.should be_complete
#    end
#  end

#  context "service alipay_direct" do
#    before do
#      @gateway = Spree::Gateway::AlipayDirect.create!(alipay_config)
#    end
#    it "pay an order successfully" do
#      add_to_cart
#      fill_in_billing
#      click_button "Save and Continue"
#      # Delivery step doesn't require any action
#      click_button "Save and Continue"
#      # alipay is first and choosed
#      choose( @gateway.name)
#      click_button "Save and Continue"
#      # should redirect to alipay casher page
#      page.should have_content( product.price.to_s )
#      #Spree::Payment.last.should be_complete
#    end
#  end

  context "service alipay_wap" do
    before do
      @gateway = Spree::Gateway::AlipayWap.create!(alipay_config)
    end

    it "pay an order successfully" do

      add_to_cart
      fill_in_billing

      click_button "Save and Continue"
      # Delivery step doesn't require any action
      click_button "Save and Continue"

      # alipay is first and choosed
      choose( @gateway.name)
      click_button "Save and Continue"
      # should redirect to alipay casher page
      expect(page).to have_selector('#logon_phone')

      #Spree::Payment.last.should be_complete
    end

  end


  def fill_in_billing
    # copy from spree/frontend/spec/checkout_spec
    address = "order_bill_address_attributes"
    fill_in "#{address}_firstname", with: "Ryan"
    fill_in "#{address}_lastname", with: "Bigg"
    fill_in "#{address}_address1", with: "143 Swan Street"
    fill_in "#{address}_city", with: "Richmond"
    select country.name, from: "#{address}_country_id"
    select state.name, from: "#{address}_state_id"
    fill_in "#{address}_zipcode", with: "12345"
    fill_in "#{address}_phone", with: "(555) 555-5555"
  end

  def add_to_cart

    visit spree.root_path
    click_link product.name
    click_button 'Add To Cart'
    click_button 'Checkout'

    # spree_auth_devise requried
    within("#guest_checkout") do
      fill_in "Email", :with => "test@example.com"
      click_button 'Continue'
    end
  end

end
