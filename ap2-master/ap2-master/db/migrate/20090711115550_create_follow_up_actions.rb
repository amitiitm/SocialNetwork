class CreateFollowUpActions < ActiveRecord::Migration
  def self.up
    create_table :follow_up_actions do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :follow_up_actions
  end
end
