class CreateSalespeople < ActiveRecord::Migration
  def self.up
    create_table :salespeople do |t|
          t.column :company_id, :int, :null=>false
          t.column :created_by, :int
          t.column :created_at, :datetime
          t.column :updated_by, :int
          t.column :updated_at, :datetime
          t.column :trans_flag, :string,:limit=>1,:default=>'A'
          t.column :update_flag, :string,:limit=>1,:default=>'Y'
          t.column :lock_version, :int, :default=>0
          t.column :category, :string,:limit=>25
          t.column :code, :string,:limit=>25, :null=>false
          t.column :name, :string,:limit=>50
          t.column :address1, :string,:limit=>50
          t.column :address2, :string,:limit=>50
          t.column :city, :string,:limit=>25
          t.column :state, :string,:limit=>25
          t.column :zip, :string,:limit=>15
          t.column :country, :string,:limit=>20
          t.column :phone1, :string,:limit=>50
          t.column :fax1, :string,:limit=>50
          t.column :contact1, :string,:limit=>50
          t.column :commn_type, :string,:limit=>4
          t.column :flat_per, :decimal,:precision=>6, :scale=>2
          t.column :a_per, :decimal,:precision=>6, :scale=>2
          t.column :b_per, :decimal,:precision=>6, :scale=>2
          t.column :c_per, :decimal,:precision=>6, :scale=>2
          t.column :d_per, :decimal,:precision=>6, :scale=>2
          t.column :e_per, :decimal,:precision=>6, :scale=>2
          t.column :f_per, :decimal,:precision=>6, :scale=>2
          t.column :g_per, :decimal,:precision=>6, :scale=>2
          t.column :h_per, :decimal,:precision=>6, :scale=>2
          t.column :i_per, :decimal,:precision=>6, :scale=>2
          t.column :j_per, :decimal,:precision=>6, :scale=>2
          t.column :gross_margin_per, :decimal,:precision=>6, :scale=>2
          t.column :commn_payment_type, :string,:limit=>2,:default=>'A'
          t.column :id_prefix, :string,:limit=>8
          t.column :commission_on_receipt, :decimal,:precision=>6, :scale=>2
    end
  end

  def self.down
    drop_table :salespeople
  end
end
