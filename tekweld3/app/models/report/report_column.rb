class Report::ReportColumn < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General

  belongs_to :report, :class_name => 'Report::Report'
  
  
  def fill_default_detail_values
    #  item_qty ||= nulltozero(item_qty)
    #  clear_qty ||= nulltozero(clear_qty)
    #  ref_qty ||= nulltozero(ref_qty)
    #  item_price ||= nulltozero(item_price)
 
  end
end
