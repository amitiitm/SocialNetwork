class TaxItem < ActiveRecord::Base
  belongs_to :product_tax
  
  #validates_presence_of :name, :message => "Name can't be blank"
  validates_presence_of :description, :message => "Description can't be blank"
  validates_presence_of :percentage, :message => "Percentage can't be blank"  
end
