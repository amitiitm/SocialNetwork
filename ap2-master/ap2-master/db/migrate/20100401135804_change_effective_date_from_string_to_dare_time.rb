class ChangeEffectiveDateFromStringToDareTime < ActiveRecord::Migration
  def self.up
    change_column :rate_sheets, :effective_date, :datetime
  end

  def self.down
    change_column :rate_sheets, :effective_date, :string
  end
end
