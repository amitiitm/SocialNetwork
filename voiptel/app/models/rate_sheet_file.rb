class RateSheetFile < ActiveRecord::Base
  belongs_to :my_file, :dependent => :destroy
  belongs_to :rate_sheet
  
  before_save :check_mapped  
  after_save  :check_rate_sheet_mapped
  has_many :rates
  
  attr_accessor :sample_cache, :options_cache
  
  def sample
    self.sample_cache ||= get_samples
  end
  
  def select_options
    self.options_cache ||= get_header_options
  end

  private
  
  def check_rate_sheet_mapped
    if not self.new_record?
      mp = true
      for rsf in self.rate_sheet.rate_sheet_files
        if not rsf.mapped
          mp = false
        end      
      end
      self.rate_sheet.mapped = mp
      self.rate_sheet.save
      true
    end
  end
  
  def check_mapped
    if self.col_desc && self.col_prefix && self.col_rate
      self.mapped = true
    else
      self.mapped = false
    end
    true
  end
  
  def get_header_options
    o = []    
    self.sample[0].each_index {|i| o << [self.sample[0][i], i]}
    o
  end
  
  def get_samples
    puts "samples dude"    
    rows = []    
    Excelsior::Reader.rows(File.open(self.my_file.path, 'rb')) do |row|
      rows << row
      break if rows.size == 10
    end
    rows    
  end
end
