class AddFeedbackToCdr < ActiveRecord::Migration
  def self.up
    add_column :cdrs, :feedback_id, :integer
  end

  def self.down
    remove_column :cdrs, :feedback_id
  end
end
