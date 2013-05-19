class CreateCatalogOpenReceivables < ActiveRecord::Migration
  def self.up
    create_table :catalog_open_receivables do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.string    :account_id, :limit=>18
      t.string    :name, :limit=>100
      t.string    :trans_period, :limit=>8
      t.string    :trans_bk, :limit=>4
      t.string    :trans_no, :limit=>10
      t.string    :inv_no, :limit=>15
      t.timestamp :trans_dt
      t.string    :terms, :limit=>8
      t.timestamp :due_dt
      t.decimal   :inv_amt , :precision=>12, :scale=>2
      t.decimal   :balance_amt , :precision=>12, :scale=>2
    end
  end

  def self.down
    drop_table :catalog_open_receivables
  end
end
