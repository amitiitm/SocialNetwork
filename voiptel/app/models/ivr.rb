class Ivr < ActiveRecord::Base
  acts_as_tree :order => :name
  
  attr_accessor :new_category
  belongs_to :category, :class_name => "IvrCategory", :foreign_key => "ivr_category_id"
  
  validates_presence_of :name, :message => "Name can't be blank"
  
  def new_category=(name)
    if not name.blank?
      self.category = IvrCategory.new(:name => name)
      self.category.save
    end
  end
  
  def all_children
    all = []
    self.children.each do |category|
      all << category
      root_children = category.all_children.flatten
      all << root_children unless root_children.empty?
    end
    return all.flatten
  end
end
