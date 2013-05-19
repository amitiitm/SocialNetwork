class AddNameAndCityToTestimonials < ActiveRecord::Migration
  def self.up
    add_column :testimonials, :name, :string
    add_column :testimonials, :city, :string
  end

  def self.down
    remove_column :testimonials, :city
    remove_column :testimonials, :name
  end
end
