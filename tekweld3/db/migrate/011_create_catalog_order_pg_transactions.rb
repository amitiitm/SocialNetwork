class CreateCatalogOrderPgTransactions < ActiveRecord::Migration
  def self.up
    create_table :catalog_order_pg_transactions do |t|
      t.integer   :company_id, :null=>false, :DEFAULT=>0
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.integer   :catalog_order_id
      t.string    :mc_gross, :limit=>10
      t.string    :protection_eligibility, :limit=>15
      t.string    :payer_id, :limit=>25
      t.string    :address_street, :limit=>100
      t.string    :payment_date, :limit=>25
      t.string    :payment_status, :limit=>15
      t.string    :charset, :limit=>15
      t.string    :address_zip, :limit=>15
      t.string    :mc_shipping, :limit=>50
      t.string    :mc_handling, :limit=>50
      t.string    :first_name, :limit=>100
      t.string    :mc_fee, :limit=>15
      t.string    :address_country_code, :limit=>15
      t.string    :address_name, :limit=>50
      t.string    :notify_version, :limit=>10
      t.string    :reason_code, :limit=>50
      t.string    :custom, :limit=>50
      t.string    :business, :limit=>50
      t.string    :address_country, :limit=>15
      t.string    :address_city, :limit=>25
      t.string    :verify_sign, :limit=>100
      t.string    :payer_email, :limit=>100
      t.string    :parent_txn_id, :limit=>50
      t.string    :txn_id, :limit=>50
      t.string    :payment_type, :limit=>25
      t.string    :last_name, :limit=>50
      t.string    :address_state, :limit=>25
      t.string    :receiver_email, :limit=>50
      t.string    :payment_fee, :limit=>15
      t.string    :shipping_discount, :limit=>15
      t.string    :quantity, :limit=>10
      t.string    :insurance_amount, :limit=>15
      t.string    :receiver_id, :limit=>50
      t.string    :discount, :limit=>15
      t.string    :mc_currency, :limit=>10
      t.string    :residence_country, :limit=>25
      t.string    :test_ipn, :limit=>50
      t.string    :shipping_method, :limit=>25
      t.string    :transaction_subject, :limit=>50
      t.string    :payment_gross, :limit=>15
      t.string    :invoice, :limit=>25
      t.string    :transaction_text, :limit=>1500
      t.string    :Tax, :limit=>15
      t.string    :txn_type, :limit=>15
      t.string    :item_name, :limit=>50
      t.string    :action, :limit=>15
      t.string    :pending_reason, :limit=>50
      t.string    :payer_status, :limit=>15
      t.string    :controller, :limit=>50
      t.string    :address_status, :limit=>15
      t.string    :num_cart_items, :limit=>5
    end
  end

  def self.down
    drop_table :catalog_order_pg_transactions
  end
end
