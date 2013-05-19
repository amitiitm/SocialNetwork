class Report::ReportLayoutGroup < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General

  belongs_to :report_layouts, :class_name => 'Report::ReportLayout'
  belongs_to :report_columns, :class_name => 'Report::ReportColumn'
end
