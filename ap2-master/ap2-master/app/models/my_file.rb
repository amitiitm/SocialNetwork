class MyFile < ActiveRecord::Base
  belongs_to :folder
  has_many :rate_sheet_files
  has_one :rate_sheet, :through => :rate_sheet_files
  
  validates_presence_of :name
  validate :existance_of_file
  
  before_create :magick
  after_destroy :delete_file
  
  attr_accessor :tmp_location
  
  def path
    File.join(STR, self.folder.uuid, "#{self.uuid}.file")
  end
  private
  
  def delete_file
    self.folder.files_count -= 1
    self.folder.save
    File.delete(File.join(STR, self.folder.uuid, "#{self.uuid}.file"))    
  end
  
  def existance_of_file
    if self.tmp_location
      unless File.exists?(self.tmp_location)
        self.errors.add(:file, "does not exists!")
      end      
    else
      self.errors.add(:file, "does not exists!")
    end
  end
  
  def magick
    success = false
    folder = Folder.find(:first, :order => "files_count ASC")
    self.folder = folder
    self.uuid = Guid.new.to_s
    new_file = File.join(STR, self.folder.uuid, "#{self.uuid}.file")
    `cp -f #{self.tmp_location} #{new_file}`
    unless File.exists?(new_file)
      self.errors.add(:file, "was not saved properly!")
    else
      success = true
      folder.files_count += 1
      folder.save
    end
    success
  end
end
