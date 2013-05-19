class CreatePaymentCustomerPaymentProfiles < ActiveRecord::Migration
  def change
    create_table :payment_customer_payment_profiles do |t|

      t.timestamps
    end
  end
end
