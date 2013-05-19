class AlterBlogs < ActiveRecord::Migration
  def self.up
    add_column :blogs,:author_name, :string, :limit=>100
    add_column :blogs,:author_email, :string, :limit=>100
    add_column :blogs,:author_homepage_url,:string, :limit=>150
    add_column :blogs,:approval_flag,:string, :limit=>1,:default=>'N'
  end

  def self.down
    remove_column :blogs,:author_name
    remove_column :blogs,:author_email
    remove_column :blogs,:author_homepage_url
    remove_column :blogs,:approval_flag,:string
  end
end