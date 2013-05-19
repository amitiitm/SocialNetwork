class CreateDistributions < ActiveRecord::Migration
  def self.up
    create_table :distributions do |t|
      t.integer :distributor_id
      t.integer :cards_start
      t.integer :cards_end
      t.integer :value
      t.datetime :activation_date

      t.timestamps
    end
  end

  def self.down
    drop_table :distributions
  end
end
