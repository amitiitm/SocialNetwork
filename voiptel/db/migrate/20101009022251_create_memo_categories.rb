class CreateMemoCategories < ActiveRecord::Migration
  def self.up
    create_table :memo_categories do |t|
      t.string :category

      t.timestamps
    end
  end

  def self.down
    drop_table :memo_categories
  end
end
