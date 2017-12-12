require 'spec_helper'
#copy from https://raw.github.com/radar/better_spree_paypal_express/master/spec/features/paypal_spec.rb
#http://sandbox.alipaydev.com/index.htm
#sandbox_areq22@aliyun.com
#http://openapi.alipaydev.com/gateway.do
describe "Alipay", :js => true, :type => :feature do
  include_context 'checkout setup'

  let!(:product) { FactoryGirl.create(:product, :name => 'iPad') }
  let(:country) { create(:country, name: 'United States of America', iso_name: 'UNITED STATES') }
  let(:state) { create(:state, name: 'Alabama', abbr: 'AL', country: country) }

  before do
    @gateway = Spree::Gateway::AlipayDualfun.create!({
      preferred_alipay_pid: ENV['ALIPAY_PID'],
      preferred_alipay_key: ENV['ALIPAY_KEY'],
      name: "Alipay",
      active: true,
    })
  end


  it "pays for an order successfully" do

    visit spree.root_path
    click_link product.name
    click_button 'Add To Cart'
    click_button 'Checkout'

    within("#guest_checkout") do
      fill_in "Email", :with => "test@example.com"
      click_button 'Continue'
    end

    fill_in_billing
    click_button "Save and Continue"
    # Delivery step doesn't require any action
    click_button "Save and Continue"

    choose( @gateway.name)
    click_button "Save and Continue"
    # should redirect to  pingpp mock page
    find("#btn_pay").click
    #page.should have_content("Your order has been processed successfully")
    #Spree::Payment.last.should be_complete
  end

  # copy from spree/frontend/spec/checkout_spec
  def fill_in_billing
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
end
