require 'spec_helper'
#copy from https://raw.github.com/radar/better_spree_paypal_express/master/spec/features/paypal_spec.rb
#http://sandbox.alipaydev.com/index.htm
#sandbox_areq22@aliyun.com
#http://openapi.alipaydev.com/gateway.do
describe "Alipay", :js => true, :type => :feature do
  let!(:product) { FactoryGirl.create(:product, :name => 'iPad') }

  before do

    FactoryGirl.create(:shipping_method)
  end


  context " service alipay_dualfun" do
    before do
      @gateway = Spree::Gateway::AlipayDualfun.create!({
        preferred_partner: '2088002627298374',
        preferred_sign: 'f4y25qc539qakg734vn2jpqq6gmybxoz',
        name: "Alipay",
        active: true,
      })
    end
    it "pay an order successfully" do
      #order[payments_attributes][][payment_method_id]
      #order_payments_attributes__payment_method_id_1
      payment_method_css = "order_payments_attributes__payment_method_id_#{@gateway.id}"

      add_to_cart
      fill_in_billing

      click_button "Save and Continue"
      # Delivery step doesn't require any action
      click_button "Save and Continue"

      # alipay is first and choosed
      choose( payment_method_css) #payment_method_css
      click_button "Save and Continue"
      # should redirect to alipay casher page
      expect(page).to have_selector('#orderContainer')

      page.should have_content( product.price.to_s )
      #Spree::Payment.last.should be_complete
    end

  end

  context "service alipay_direct" do
    before do
      raise "plese set ALIPAY_KEY, ALIPAY_PID" unless  ENV['ALIPAY_PID'] && ENV['ALIPAY_KEY']
      @gateway = Spree::Gateway::AlipayDirect.create!({
          preferred_partner: ENV['ALIPAY_PID'],
          preferred_sign: ENV['ALIPAY_KEY'],
          name: "AlipayDirect",
          active: true,
        })
    end
    it "pay an order successfully" do
      #order[payments_attributes][][payment_method_id]
      #order_payments_attributes__payment_method_id_1
      payment_method_css = "order_payments_attributes__payment_method_id_#{@gateway.id}"

      add_to_cart

      fill_in_billing
      click_button "Save and Continue"
      # Delivery step doesn't require any action
      click_button "Save and Continue"

      # alipay is first and choosed
      choose( payment_method_css) #payment_method_css
      click_button "Save and Continue"
      # should redirect to alipay casher page
      page.should have_content( product.price.to_s )
      #Spree::Payment.last.should be_complete
    end
  end

  context "service alipay_wap" do
    before do
      raise "plese set ALIPAY_KEY, ALIPAY_PID" unless  ENV['ALIPAY_PID'] && ENV['ALIPAY_KEY']
      @gateway = Spree::Gateway::AlipayWap.create!({
        preferred_partner: ENV['ALIPAY_PID'],
        preferred_sign: ENV['ALIPAY_KEY'],
        name: "AlipayWap",
        active: true,
      })
    end

    it "pay an order successfully" do
      #order[payments_attributes][][payment_method_id]
      #order_payments_attributes__payment_method_id_1
      payment_method_css = "order_payments_attributes__payment_method_id_#{@gateway.id}"

      add_to_cart
      fill_in_billing

      click_button "Save and Continue"
      # Delivery step doesn't require any action
      click_button "Save and Continue"

      # alipay is first and choosed
      choose( payment_method_css) #payment_method_css
      click_button "Save and Continue"
      # should redirect to alipay casher page
      expect(page).to have_selector('#logon_phone')

      #Spree::Payment.last.should be_complete
    end

  end


  def fill_in_billing

    within("#billing") do
      fill_in "First Name", :with => "Test"
      fill_in "Last Name", :with => "User"
      fill_in "Street Address", :with => "1 User Lane"
      # City, State and ZIP must all match for PayPal to be happy
      fill_in "City", :with => "Adamsville"
      select "United States of America", :from => "order_bill_address_attributes_country_id"
      select "Alabama", :from => "order_bill_address_attributes_state_id"
      fill_in "Zip", :with => "35005"
      fill_in "Phone", :with => "555-AME-RICA"
    end
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
