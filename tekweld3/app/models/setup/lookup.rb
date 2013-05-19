class Setup::Lookup < ActiveRecord::Base
  require 'has_finder'
  include UserStamp
  include Dbobject
end
