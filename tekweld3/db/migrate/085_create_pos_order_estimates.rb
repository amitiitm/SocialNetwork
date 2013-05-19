class CreatePosOrderEstimates < ActiveRecord::Migration
  def self.up
    create_table :pos_order_estimates do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.integer   :pos_order_id
      t.string    :serial_no,   :limit => 6
      t.string    :item_type,   :limit => 1
      t.integer   :item_id,  :null => false
      t.string    :item_code,      :limit => 25
      t.string    :item_description,      :limit => 255
      t.decimal   :item_cost , :precision=>12, :scale=>2
      t.decimal   :item_price , :precision=>12, :scale=>2
      t.decimal   :item_qty , :precision=>8, :scale=>2
      t.decimal   :total_cost , :precision=>12, :scale=>2
      t.decimal   :total_amt , :precision=>12, :scale=>2
      t.string    :trans_bk,      :limit => 4  , :null => false
      t.string    :trans_no,      :limit => 18 , :null => false
      t.timestamp :trans_date
      t.string    :account_period_code,    :limit => 8 , :null => false
    end
  end

  def self.down
    drop_table :pos_order_estimates
  end
end
