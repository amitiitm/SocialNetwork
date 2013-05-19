class Dbrecord < ActiveRecord::Base
  include UserStamp
  include Dbobject
end
