class Testimonial < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :user_id
  validates_presence_of :name
  validates_presence_of :city
  validates_presence_of :message
  
end
