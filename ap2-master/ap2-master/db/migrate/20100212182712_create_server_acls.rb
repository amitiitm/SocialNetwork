class CreateServerAcls < ActiveRecord::Migration
  def self.up
    create_table :server_acls do |t|
      t.string :cidr

      t.timestamps
    end
  end

  def self.down
    drop_table :server_acls
  end
end
