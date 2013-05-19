class AddShaftakBaghaliToVoicemail < ActiveRecord::Migration
  def self.up
    add_column :voicemail, :account_id, :integer
    add_column :voicemail, :subscriber_id, :integer
    add_column :voicemail, :created_at, :datetime
    add_column :voicemail, :updated_at, :datetime
  end

  def self.down
    remove_column :voicemail, :updated_at
    remove_column :voicemail, :created_at
    remove_column :voicemail, :subscriber_id
    remove_column :voicemail, :account_id
  end
end