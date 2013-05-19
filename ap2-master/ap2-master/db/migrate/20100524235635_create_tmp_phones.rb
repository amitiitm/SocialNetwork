class CreateTmpPhones < ActiveRecord::Migration
  def self.up
    create_table :tmp_phones do |t|
      t.string :number, :limit => 20
      t.string :area_code, :limit => 10
      t.integer :card_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tmp_phones
  end
end
