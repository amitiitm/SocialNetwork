class CardCdr < ActiveRecord::Base
  belongs_to :card
  belongs_to :carrier
  belongs_to :zone
  belongs_to :tmp_phone
  belongs_to :did
  belongs_to :country, :class_name => "V2Country", :foreign_key => "country_id"
  
  named_scope :answered_calls_between, lambda { |range|
	  {
	    :conditions => {:disposition => "ANSWER", :date => range}
	  }
	}
	
	named_scope :answered, :conditions => {:disposition => "ANSWER"}
	named_scope :answer, :conditions => {:disposition => "ANSWER"}
	
	named_scope :between, lambda { |range|
	  {
	    :conditions => {:date => range}
	  }
	}
	  
end
