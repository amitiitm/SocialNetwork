class CreateVoipForwardings < ActiveRecord::Migration
  def self.up
    create_table :voip_forwardings do |t|
      t.string :number, :limit => 20
      t.decimal :rate, :precision => 6, :scale => 4
      t.integer :did_id
      t.integer :account_id
      t.integer :endpoint_id

      t.timestamps
    end
  end

  def self.down
    drop_table :voip_forwardings
  end
end
