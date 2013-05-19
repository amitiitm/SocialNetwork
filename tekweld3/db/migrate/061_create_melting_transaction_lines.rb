class CreateMeltingTransactionLines < ActiveRecord::Migration
  def self.up
    create_table :melting_transaction_lines do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version, :default => 0
      t.integer   :melting_transaction_id, :default => 0
      t.string    :description, :limit=>100
      t.decimal    :gold_weight, :precision=>10, :scale=>5
      t.decimal   :gold_per, :precision=>5, :scale=>2
      t.decimal   :total_value, :precision=>12, :scale=>2
      t.decimal   :offer_value, :precision=>12, :scale=>2
      t.integer   :total_pcs
      t.string    :serial_no, :limit=>25
    end
  end

  def self.down
    drop_table :melting_transaction_lines
  end
end
