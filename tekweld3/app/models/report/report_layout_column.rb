class Report::ReportLayoutColumn < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General

 
  belongs_to :report_layouts, :class_name => 'Report::ReportLayout',
    :foreign_key => "report_layout_id"                   
  belongs_to :report_columns, :class_name => 'Report::ReportColumn',
    :foreign_key => "report_column_id"                    

  
  def fill_default_detail_values
    #  item_qty ||= nulltozero(item_qty)
    #  clear_qty ||= nulltozero(clear_qty)
    #  ref_qty ||= nulltozero(ref_qty)
    #  item_price ||= nulltozero(item_price)
 
  end
  
 
  
end
