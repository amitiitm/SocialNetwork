class CreateDomains < ActiveRecord::Migration
  def self.up
    create_table :domains do |t|
      t.string :domain
      t.string :transport
      t.boolean :enabled
      t.integer :account_id

      t.timestamps
    end
  end

  def self.down
    drop_table :domains
  end
end
