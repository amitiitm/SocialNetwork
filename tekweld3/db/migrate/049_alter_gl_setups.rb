class AlterGlSetups < ActiveRecord::Migration
  def self.up
    add_column :gl_setups, :insurance_purchase_account_id, :integer
    add_column :gl_setups, :insurance_sales_account_id, :integer
    add_column :gl_setups, :faar_invoice_gl_account_id, :integer
    add_column :gl_setups, :faar_bank_id, :integer
    add_column :gl_setups, :faar_credit_gl_account_id, :integer
    add_column :gl_setups, :faap_credit_gl_account_id, :integer
    add_column :gl_setups, :faap_bank_id, :integer
  end

  def self.down
    remove_column :gl_setups, :insurance_purchase_account_id
    remove_column :gl_setups, :insurance_sales_account_id
    remove_column :gl_setups, :faar_invoice_gl_account_id
    remove_column :gl_setups, :faar_bank_id
    remove_column :gl_setups, :faar_credit_gl_account_id
    remove_column :gl_setups, :faap_credit_gl_account_id
    remove_column :gl_setups, :faap_bank_id
  end
end
