class RateSheet < ActiveRecord::Base
  has_many :trunks
  belongs_to :carrier
  belongs_to :trunk
  has_many :rates
  
  has_many :rate_sheet_files, :dependent => :destroy
  has_many :my_files, :through => :rate_sheet_files
  has_many :revesions, :class_name => "RateSheetRevesion"
  
  attr_accessor :use_trunk, :files
  
  after_save :set_files      
  #after_save :check_trunks
  
  private
  
  def set_files
    if self.files.class == Array
      self.files.each do |fid|
        rf = RateSheetFile.new(:rate_sheet_id => self.id, :my_file_id => fid.to_i)
        convert_to_unix(MyFile.find(fid.to_i).path)
        if rf.save
        else
          logger.info { "-------------NOT SAVED: #{rf.errors.full_messages.join('\n')}" }
        end
      end
    end
  end
  
  def convert_to_unix(p)
    cmds = [
      "perl -pi -e 's/\\r\\n/\\n/g' #{p}",
      "perl -pi -e 's/\\n\\r/\\n/g' #{p}",
      "perl -pi -e 's/\\r/\\n/g' #{p}",
      "perl -pi -e 's/\\t//g' #{p}",
    ]
    cmds.each do |c|
      `#{c}`
    end    
  end    
end
=begin
  def using_trunk?(tid)
    if self.trunks.find(:first, :conditions => {:id => tid})
      true
    else
      false
    end    
  end
  
  private
  
  def check_trunks
    if self.use_trunk.class == HashWithIndifferentAccess
      self.use_trunk.keys.each do |tid|
        update_trunk(tid.to_i, self.use_trunk[tid])
      end
    end
  end
  
  def update_trunk(tid, value)
    tr = self.carrier.trunks.find(:first, :conditions => {:id => tid})
    if value == "0"  
      tr.rate_sheet_id = nil
      tr.save  
    else
      tr.rate_sheet = self
      tr.save
    end
  end
=end
