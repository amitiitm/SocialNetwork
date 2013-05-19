class CreateBlogs < ActiveRecord::Migration
  def self.up
    create_table :blogs do |t|
        t.column :blog_name, :string, :limit=>50
        t.column :blog_description, :string, :limit=>5000
    end
  end

  def self.down
    drop_table :blogs
  end
end



