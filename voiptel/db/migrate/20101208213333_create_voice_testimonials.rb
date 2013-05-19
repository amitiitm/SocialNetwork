class CreateVoiceTestimonials < ActiveRecord::Migration
  def self.up
    create_table :voice_testimonials do |t|
      t.string :file, :limit => 40;
      t.string :location, :limit => 10;
      t.string :customer_type, :limit => 10;
      t.integer :customer_id
      t.timestamps
    end
  end

  def self.down
    drop_table :voice_testimonials
  end
end
