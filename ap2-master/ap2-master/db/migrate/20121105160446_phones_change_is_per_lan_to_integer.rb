class PhonesChangeIsPerLanToInteger < ActiveRecord::Migration
  def self.up
      change_table :phones do |t|
          t.change :is_per_lan, :integer
      end
  end

  def self.down
  end
end
