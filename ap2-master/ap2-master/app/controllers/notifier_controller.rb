class NotifierController < ApplicationController
  layout nil
  
  def monday_sorry
    @user = User.first
    @credit = 2.0
  end
  
  def fix_rates
    @user = User.first
    @credit = 2.0
    @cdrs = Cdr.answered.find(:all, :conditions => ["account_id = ? and duration > ?", 1, 59], :order => "date DESC", :limit => 10)
  end
  
  def welcome_test
    @account = Account.first
    @user = @account.users.first    
  end
  
  def welcome_tidy
    welcome_test
  end
  
  def new_access_numbers
    @user = Account.find(135).users.first
  end
  
end
