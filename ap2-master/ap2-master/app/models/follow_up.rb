class FollowUp < ActiveRecord::Base
  belongs_to :follow_up_action
  belongs_to :admin_user
  belongs_to :account
  
  def to_s
    "follow_up"    
  end
end
