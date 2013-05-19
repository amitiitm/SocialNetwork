class CreateCidProblems < ActiveRecord::Migration
  def self.up
    create_table :cid_problems do |t|
      t.integer :did_id
      t.text :sip_headers
      t.boolean :notified, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :cid_problems
  end
end
