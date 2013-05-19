class CreateMemoTypes < ActiveRecord::Migration
  def self.up
    create_table :memo_types do |t|
      t.string :subject
      t.integer :memo_category_id

      t.timestamps
    end
  end

  def self.down
    drop_table :memo_types
  end
end
