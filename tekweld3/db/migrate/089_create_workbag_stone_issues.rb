class CreateWorkbagStoneIssues < ActiveRecord::Migration
  def self.up
    create_table :workbag_stone_issues do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.integer   :workbag_id
      t.string    :trans_bk,      :limit => 4  , :null => false
      t.string    :trans_no,      :limit => 18 , :null => false
      t.timestamp :trans_date
      t.string    :account_period_code,    :limit => 8 , :null => false
      t.string    :serial_no,   :limit => 6
      t.string    :item_type,   :limit => 1
      t.integer   :stone_lot_id
      t.string    :stone_lot_number,      :limit => 25
      t.integer   :stone_packet_id
      t.string    :stone_packet_code,      :limit => 25
      t.string    :stone_type,:limit =>18
      t.string    :stone_shape,:limit =>18
      t.decimal    :stone_size, :precision=>7, :scale=>2
      t.string    :stone_quality,:limit =>18
      t.string    :stone_color,:limit =>18
      t.string    :stone_clarity,:limit =>18
      t.string    :stone_setting,:limit =>18
      t.decimal   :wt, :precision=>12, :scale=>3
      t.decimal   :cost, :precision=>12, :scale=>2
      t.decimal   :price, :precision=>12, :scale=>2
      t.decimal   :qty, :precision=>6, :scale=>2
      t.decimal   :total_wt, :precision=>12, :scale=>3
      t.decimal   :total_cost, :precision=>12, :scale=>2
      t.decimal   :total_amt, :precision=>12, :scale=>2
    end
  end

  def self.down
    drop_table :workbag_stone_issues
  end
end
