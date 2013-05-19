class CreateBusinessDids < ActiveRecord::Migration
  def self.up
    create_table :business_dids do |t|
      t.integer :did_id
      t.integer :account_id

      t.timestamps
    end
  end

  def self.down
    drop_table :business_dids
  end
end
