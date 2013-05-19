class Report::ReportLayoutUser < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General

  belongs_to :report_layouts, :class_name => 'Report::ReportLayout'
  belongs_to :users, :class_name => 'Admin::User'
 
end
