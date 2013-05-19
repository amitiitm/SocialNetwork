class MemoUpdateNotification < ActiveRecord::Base
  belongs_to :memo_update
  belongs_to :notification
end
