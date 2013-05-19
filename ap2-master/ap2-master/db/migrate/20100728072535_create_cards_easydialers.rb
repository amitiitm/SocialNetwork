class CreateCardsEasydialers < ActiveRecord::Migration
  def self.up
    create_table :cc_easydialers do |t|
      t.string :phone_number
      t.string :easy_dial_number
      t.integer :freq
      t.integer :tmp_phone_id
      t.integer :duration

      t.timestamps
    end
  end

  def self.down
    drop_table :cc_easydialers
  end
end
