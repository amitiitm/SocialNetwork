class CreateSipTrunks < ActiveRecord::Migration
  def self.up
    create_table :sip_trunks do |t|
      t.string :ip
      t.integer :account_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sip_trunks
  end
end
