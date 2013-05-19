class OrderTransaction < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  belongs_to :order
  belongs_to :transaction_reference
  belongs_to :account
  serialize :params
  
  STATUS = ["Failed", "Success", "Refunded", "Void"]
  FAILED    = 0
  SUCCESS   = 1
  REFUNDED  = 2
  VOID      = 3

  CUSTOMER = 1
  AUTO_RECHARGE = 2
  IVR = 3
  AGENT = 4

  
  named_scope :between, lambda { |range| { :conditions => {:created_at => range} } }
  named_scope :success, :conditions => {:success => true}
  
  attr_accessor :external_error
  
  liquid_methods :formatted_amount, :date
  
  def formatted_amount
    number_to_currency(self.amount / 100.0)
  end
  
  def date
    self.created_at
  end
  
  def response=(response)
    self.external_error = response.external_error?
    self.success        = response.success?
    self.authorization  = response.authorization
    self.message        = response.message
    self.params         = response.params
    self.status         = (self.success) ? 1 : 0
  end
  
  def transaction_id
    return self.params["TRANSACTIONID"] if self.params["TRANSACTIONID"]
    return self.params["transactionid"] if self.params["transactionid"]
    return self.params["transaction_id"] if self.params["transaction_id"]
    return nil
  end
  
  def status_string
    STATUS[self.status]
  end
  
  def void
    self.status = VOID
    save
  end
  
end
