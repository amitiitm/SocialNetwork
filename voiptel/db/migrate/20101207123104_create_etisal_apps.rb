class CreateEtisalApps < ActiveRecord::Migration
  def self.up
    create_table :etisal_apps do |t|
      t.string :name
      t.string :description
      t.timestamps
    end
  end

  def self.down
    drop_table :etisal_apps
  end
end
