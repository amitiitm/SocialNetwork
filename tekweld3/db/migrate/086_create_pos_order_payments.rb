class CreatePosOrderPayments < ActiveRecord::Migration
  def self.up
    create_table :pos_order_payments do |t|
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
      t.string    :payment_method,      :limit => 50
      t.string    :reference_no,      :limit => 50
      t.decimal   :payment_amt , :precision=>12, :scale=>2
      t.timestamp :check_date
      t.decimal   :return_amt , :precision=>12, :scale=>2
    end
  end

  def self.down
    drop_table :pos_order_payments
  end
end
