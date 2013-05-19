class AddSavedToVoiceTestimonials < ActiveRecord::Migration
  def self.up
    add_column :voice_testimonials, :saved, :boolean
  end

  def self.down
    remove_column :voice_testimonials, :saved
  end
end
