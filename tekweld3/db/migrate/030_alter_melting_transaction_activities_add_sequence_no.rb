class AlterMeltingTransactionActivitiesAddSequenceNo < ActiveRecord::Migration
  def self.up
    #add_column :melting_transaction_activities, :sequence_no, :integer
  end

  def self.down
    #remove_column :melting_transaction_activities
  end
end

