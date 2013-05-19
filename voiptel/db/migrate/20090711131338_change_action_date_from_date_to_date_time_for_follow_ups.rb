class ChangeActionDateFromDateToDateTimeForFollowUps < ActiveRecord::Migration
  def self.up
    change_column :follow_ups, :action_date, :datetime
  end

  def self.down
    change_column :follow_ups, :action_date, :date    
  end
end
