class CreateCustomerActivities < ActiveRecord::Migration
  def self.up
    create_table  :customer_activities do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.integer   :customer_id
      t.string    :trans_bk, :limit => 4
      t.string    :trans_no ,:limit =>18
      t.timestamp :trans_date
      t.string    :trans_type , :limit => 1 
      t.string    :catalog_item_code,      :limit => 25
      t.string    :catalog_item_description,      :limit => 200
      t.string    :catalog_item_price,      :limit => 25
    end
  end

  def self.down
    drop_table :customer_activities
  end
end
