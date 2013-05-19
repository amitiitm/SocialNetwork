class Sales::SalesOrderArtwork < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects

  belongs_to :sales_order, :class_name => 'Sales::SalesOrder'
#  validates_uniqueness_of :serial_no, :scope=>[:sales_order_id]
  def fill_default_detail_values
    path = Setup::Type.find_by_type_cd_and_subtype_cd('UPLOAD_FOLDER','ATTACHMENT')
    if path 
      directory = path.value + 'TEKW1122'  
    end 
    # create the file path 
    filename = File.join(directory, self.artwork_file_name)    
    self.artwork_file_path = filename
  end
  
  def add_line_errors_to_header
    
  end
end
