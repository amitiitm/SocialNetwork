class CreateTemplateMemoTypes < ActiveRecord::Migration
  def self.up
    create_table :template_memo_types do |t|
      t.integer :notification_template_id
      t.integer :memo_type_id

      t.timestamps
    end
  end

  def self.down
    drop_table :template_memo_types
  end
end
