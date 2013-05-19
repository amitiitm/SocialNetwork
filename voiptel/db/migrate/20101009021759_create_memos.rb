class CreateMemos < ActiveRecord::Migration
  def self.up
    create_table :memos do |t|
      t.text :content
      t.integer :memo_type_id
      t.integer :memo_category_id
      t.boolean :followup, :default => false
      t.datetime :followup_due
      t.datetime :followup_date
      t.boolean :followuped, :default => false
      t.integer :assigned_to
      t.integer :followup_by
      t.integer :related_to
      t.integer :memoable_id
      t.string :memoable_type
      
      t.timestamps
    end
  end

  def self.down
    drop_table :memos
  end
end
