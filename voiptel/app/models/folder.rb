class Folder < ActiveRecord::Base
  has_many :my_files
  
  after_create :create_folder
  
  private
  def create_folder
    Dir.mkdir(File.join(STR, self.uuid))
  end
end
