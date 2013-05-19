class Credit < ActiveRecord::Base
  belongs_to :account
  belongs_to :admin_user
  
  before_save :update_balance
  
  validates_presence_of :amount, :message => "Credit amount can't be blank"
  validates_presence_of :note, :message => "Note can't be blank"
  
  def validate
    # unless amount_before_type_cast.to_s =~ /^[+]?\d+$/
      # errors.add("amount", "Credit amount should not be negative")
    # end
    if category == 1 && amount < 0
      errors.add("amount", "Credit amount should not be negative")
    end
  end

  private
  def update_balance
    self.old_balance = self.account.balance
    self.account.balance = self.account.balance + self.amount
    self.account.save
  end
end
