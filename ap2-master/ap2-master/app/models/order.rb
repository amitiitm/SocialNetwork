class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :account
  belongs_to :address
  has_one :order_transaction

  attr_accessor :amount, :credit_card, :ip, :full_amount

  def purchase_by_reference(tr, tax = 0,charged_type=nil, charged_by=nil)
    self.full_amount = amount + tax
    response = GATEWAY.purchase(full_price_in_cents, tr.reference, {:ip => self.ip})
    if response.success?
      self.account.increment_cached_deposits(amount)
    end

    if response.success?
      old_balance = self.account.balance.to_f
      new_balance = self.account.balance.to_f + self.full_amount.to_f
    else
      new_balance = self.account.balance.to_f
      old_balance = self.account.balance.to_f
    end

    self.order_transaction = OrderTransaction.create(:action => "purchase",
                                                     :amount => price_in_cents,
                                                     :tax_amount => tax,
                                                     :full_amount => self.full_amount,
                                                     :old_balance => old_balance.to_f,
                                                     :new_balance => new_balance.to_f,
                                                     :charged_type => charged_type,
                                                     :charged_by => charged_by,
                                                     :response => response,
                                                     :transaction_reference_id => tr.id)
    self.order_transaction.account_id = account_id
  end

  def price_in_cents
    (amount * 100).to_i
  end

  def full_price_in_cents
    (full_amount * 100).to_i
  end

end