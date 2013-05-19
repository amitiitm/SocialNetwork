class CreateMemoryCaches < ActiveRecord::Migration
  def self.up
    create_table :memory_caches, :options => "ENGINE=MEMORY" do |t|
      t.string :k
      t.string :v

      t.timestamps
    end
  end

  def self.down
    drop_table :memory_caches
  end
end
