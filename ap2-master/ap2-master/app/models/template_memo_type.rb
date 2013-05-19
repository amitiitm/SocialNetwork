class TemplateMemoType < ActiveRecord::Base
  belongs_to :notification_template
  belongs_to :memo_type
end
