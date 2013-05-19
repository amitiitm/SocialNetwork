class CreateCustomerNotes < ActiveRecord::Migration
  def self.up
   create_table :customer_notes do |t|
        t.column :company_id, :int, :null=>false
        t.column :created_by, :int , :default=>0
        t.column :created_at, :datetime
        t.column :updated_by, :int, :default=>0
        t.column :updated_at, :datetime
        t.column :trans_dt, :datetime
        t.column :user_id, :int , :default=>0
        t.column :trans_flag, :string,:limit=>1 ,:default=>'A'
        t.column :update_flag, :string,:limit=>1 ,:default=>'A'
        t.column :lock_version, :int, :default=>0
        t.column :customer_id, :int, :default=>0
        t.column :serial_no, :string, :limit =>6
        t.column :daily_notes, :string, :limit =>100
     end
  end

  def self.down
    drop_table :customer_notes
  end
end
