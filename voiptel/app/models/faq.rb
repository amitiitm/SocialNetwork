class Faq < ActiveRecord::Base
  validates_presence_of :question, :message => "Question can't be blank"
  validates_presence_of :answer, :message => "Answer can't be blank"
  
  liquid_methods :question, :answer  
end
