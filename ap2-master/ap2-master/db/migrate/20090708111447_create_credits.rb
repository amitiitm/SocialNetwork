class CreateCredits < ActiveRecord::Migration
  def self.up
    create_table :credits do |t|
      t.decimal :amount, :precision => 12, :scale => 4
      t.string :note
      t.integer :account_id
      t.integer :admin_user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :credits
  end
end
