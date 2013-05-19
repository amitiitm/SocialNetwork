class Setup::Note < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General
  
  belongs_to :user , :class_name => 'Admin::User'

  before_create do
    self.notes_type == 'S' ? self.date_added = self.created_at : self.date_added
  end

end
