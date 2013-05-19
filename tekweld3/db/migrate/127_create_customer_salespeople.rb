class CreateCustomerSalespeople < ActiveRecord::Migration
  def self.up
    create_table  :customer_salespeople do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.integer   :customer_id
      t.string    :customer_code, :string=>100
      t.integer   :salesperson_id
      t.string    :salesperson_code, :string=>100
      
    end
  end

  def self.down
    drop_table :customer_salespeople
  end
end
