class TmpCreditCardInfo < ActiveRecord::Base
  belongs_to :address, :dependent => :destroy
  accepts_nested_attributes_for :address, :allow_destroy => true
  belongs_to :account
  belongs_to :admin_user
  
  validates_presence_of :first_name, :message => "First name can't be blank"
  validates_presence_of :last_name, :message => "Last name can't be blank"
  
  def self.select_options_for_transfer
    [["After Hangup", 1], ["Customer will add info later", 2]]
  end
  
  def self.save_credit_card account, credit_card, response
    tr = TransactionReference.new
    tr.reference = response.authorization
    length = credit_card.number.length
    tr.card_number = credit_card.number[length-4..-1]
    tr.exp_month = credit_card.month
    tr.exp_year = credit_card.year
    tr.name_on_card = "#{credit_card.first_name} #{credit_card.last_name}"
    tr.card_type = credit_card.type
    
    tr.user_id = account.account_holder.id
    tr.account_id = account.id
    tr.save
  end
  
  def self.authorize(account, credit_card)
    names = account.tmp_credit_card_infos.find(:first, :order => "created_at desc")    
    credit_card.first_name = names.first_name
    credit_card.last_name = names.last_name
    response = GATEWAY.authorize(1, credit_card)
    if response.success?
      self.save_credit_card account, credit_card, response
      names.destroy
    end    
    response
  end
end
