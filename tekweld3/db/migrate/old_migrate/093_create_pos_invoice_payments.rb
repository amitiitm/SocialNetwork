class CreatePosInvoicePayments < ActiveRecord::Migration
  def self.up
    create_table :pos_invoice_payments do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at  
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.integer   :pos_invoice_id
      t.string    :serial_no, :limit=>6
      t.string    :payment_method,:reference_no, :card_type, :limit=>50
      t.decimal   :payment_amt,:return_amt, :precision=>12, :scale=>2, :default=>0
      t.datetime  :check_date
    end
  end

  def self.down
    drop_table :pos_invoice_payments
  end
end
