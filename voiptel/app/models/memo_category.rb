class MemoCategory < ActiveRecord::Base
  has_many :memo_types
  has_many :memos
end
