class CreateShippings < ActiveRecord::Migration
  def self.up
    create_table :shippings do |t|
        t.column :company_id, :int, :null=>false
        t.column :created_by, :int
        t.column :created_at, :datetime
        t.column :updated_by, :int
        t.column :updated_at, :datetime
        t.column :trans_flag, :string,:limit=>1,:default=>'A'
        t.column :update_flag, :string,:limit=>1,:default=>'Y'
        t.column :lock_version, :int, :default=>0
        t.column :code, :string,:limit=>25, :null=>false
        t.column :name, :string,:limit=>50
        t.column :charge_flag, :string,:limit=>1,:default=>'N'
        t.column :charge_shipping, :string,:limit=>1,:default=>'N'
    end
  end

  def self.down
    drop_table :shippings
  end
end
