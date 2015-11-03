#encoding:utf-8
class CreateAlipayTransactions < ActiveRecord::Migration
  def change
    # it is reqired for
    create_table :spree_alipay_transactions do |t|
      # column for
      #   create_direct_pay_by_user
      #   trade_create_by_buyer
      t.string :trade_no, :limit=>64         #支付宝交易号
      t.float :total_fee                     #交易金额
      t.string :buyer_id, :limit=>16         #买家支付宝账户号
      t.string :buyer_email, :limit=>100     #买家支付宝账号
      t.string :payment_type, :limit => 4    #支付类型
      t.string :is_success, :limit => 1
      t.string :trade_status
      # column for trade_create_by_buyer
      t.string :refund_status
      t.string :batch_no
      t.timestamps null: false
    end
  end
end
