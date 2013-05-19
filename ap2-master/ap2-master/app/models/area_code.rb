class AreaCode < ActiveRecord::Base
  #has_many :dids
  belongs_to :country
  #has_many :assigned_dids
end