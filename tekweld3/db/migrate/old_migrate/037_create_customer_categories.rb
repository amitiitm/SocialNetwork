class CreateCustomerCategories < ActiveRecord::Migration
  def self.up
    create_table :customer_categories do |t|
      t.column :company_id, :integer, :null=>false
      t.column :created_by, :integer
      t.column :created_at, :datetime
      t.column :updated_by, :integer
      t.column :updated_at, :datetime
      t.column :trans_flag, :string,:limit=>1,:default=>'A'
      t.column :update_flag, :string,:limit=>1,:default=>'Y'
      t.column :lock_version, :integer, :default=>0
      t.column :code, :string, :limit=>25, :null=>false
      t.column :name, :string, :limit=>50
      t.column :discount_per, :decimal, :precision=>6, :scale=>2
      t.column :discount_days, :integer
      t.column :due_days, :integer
      t.column :term_code, :string, :limit=>25
      t.column :gl_accounts_receivable_id, :int
      t.column :gl_income_account_id, :int
      t.column :gl_discount_account_id, :int
    end
  end

  def self.down
    drop_table :customer_categories
  end
end
