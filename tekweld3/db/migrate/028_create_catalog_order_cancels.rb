class CreateCatalogOrderCancels < ActiveRecord::Migration
  def self.up
    create_table :catalog_order_cancels  do |t|
      t.integer   :company_id, :default => 1,   :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag, :limit => 1,   :default => "Y"
      t.string    :trans_flag, :limit => 1,   :default => "A"
      t.integer   :lock_version, :default => 0
      t.integer   :user_id, :default => 0
      t.integer   :customer_id, :default => 0
      t.string    :order_no, :limit => 50,  :default => " "
      t.timestamp :order_date
      t.string    :status, :limit => 1,   :default => "N"
      t.string    :name, :limit => 50,  :default => " "
      t.string    :bill_address1, :limit => 40,  :default => " "
      t.string    :bill_address2, :limit => 40,  :default => " "
      t.string    :bill_city, :limit => 20,  :default => " "
      t.string    :bill_state, :limit => 5,   :default => " "
      t.string    :bill_zip, :limit => 15,  :default => " "
      t.string    :bill_country,  :limit => 20,  :default => " "
      t.string    :ship_address1, :limit => 40,  :default => " "
      t.string    :ship_address2, :limit => 40,  :default => " "
      t.string    :ship_city, :limit => 20,  :default => " "
      t.string    :ship_state, :limit => 5,   :default => " "
      t.string    :ship_zip, :limit => 15,  :default => " "
      t.string    :ship_country, :limit => 20,  :default => " "
      t.string    :phone1, :limit => 15,  :default => " "
      t.string    :phone2, :limit => 15,  :default => " "
      t.string    :fax1, :limit => 15,  :default => " "
      t.string    :cell_no, :limit => 15,  :default => " "
      t.string    :email, :limit => 50,  :default => " "
      t.string    :comments, :limit => 200, :default => " "
      t.decimal   :item_qty, :precision => 10, :scale => 2
      t.decimal   :item_amt, :precision => 12, :scale => 2
      t.decimal   :ship_amt, :precision => 12, :scale => 2
      t.decimal   :tax_amt, :precision => 12, :scale => 2
      t.decimal   :net_amt, :precision => 12, :scale => 2
      t.timestamp :planned_ship_date
      t.timestamp :actual_ship_date
      t.timestamp :cancel_date
      t.string    :trans_bk, :ref_trans_bk, :limit => 4
      t.string    :trans_no, :ref_trans_no, :limit => 18
      t.timestamp :trans_date, :ref_trans_date
      t.decimal   :discount_per, :precision => 6, :scale => 2
      t.decimal   :discount_amt, :precision => 6, :scale => 2
      t.string    :remarks, :limit=>255
      t.string    :ext_ref_no, :limit => 50
      t.timestamp :ext_ref_date
    end
  end

  def self.down
    drop_table :catalog_order_cancels
  end
end
