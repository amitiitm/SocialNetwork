class CreateIvrs < ActiveRecord::Migration
  def self.up
    create_table :ivrs do |t|
      t.string :name
      t.text :en_text
      t.text :fa_text
      t.boolean :en_sound
      t.boolean :fa_sound
      t.integer :ivr_category_id
      t.timestamps
    end
    execute %{ALTER TABLE ivrs MODIFY fa_text text COLLATE utf8_unicode_ci}
  end

  def self.down
    drop_table :ivrs
  end
end
