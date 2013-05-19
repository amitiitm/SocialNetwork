class Production::ThreadColor < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects
  validates_uniqueness_of :color_number, :scope => [:thread_category]

  def add_line_errors_to_header

  end
end
