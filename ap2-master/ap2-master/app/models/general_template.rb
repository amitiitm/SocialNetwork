class GeneralTemplate < ActiveRecord::Base
  validates_presence_of :name, :message => "Name can't be blank"
  validates_presence_of :uid, :message => "Identifier can't be blank"
  validates_presence_of :template, :message => "Template can't be blank"  
end
