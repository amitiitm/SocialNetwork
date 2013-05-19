class ChangeDefaultDidTypeForDiDs < ActiveRecord::Migration
  def self.up
    change_column_default :dids, :did_type, 0
  end

  def self.down
    change_column_default :dids, :did_type, 1
  end
end