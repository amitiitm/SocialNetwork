class CreateTestimonials < ActiveRecord::Migration
  def self.up
    create_table :testimonials do |t|
      t.text :message
      t.integer :user_id
      t.boolean :publish, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :testimonials
  end
end
