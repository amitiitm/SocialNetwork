class CreateMyFiles < ActiveRecord::Migration
  def self.up
    create_table :my_files do |t|
      t.string :name
      t.string :uuid
      t.integer :folder_id

      t.timestamps
    end
  end

  def self.down
    drop_table :my_files
  end
end
