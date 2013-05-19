class CreateMetalRates < ActiveRecord::Migration
  def self.up
    create_table :metal_rates do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.timestamp :metal_rate_date , :null => false
      t.decimal   :gold_rate,      :precision => 12, :scale => 2, :default => 0.0
      t.decimal   :silver_rate,    :precision => 12, :scale => 2, :default => 0.0
      t.decimal   :platinum_rate,  :precision => 12, :scale => 2, :default => 0.0
      t.decimal   :palladium_rate, :precision => 12, :scale => 2, :default => 0.0
    end
  end

  def self.down
    drop_table :metal_rates
  end
end
