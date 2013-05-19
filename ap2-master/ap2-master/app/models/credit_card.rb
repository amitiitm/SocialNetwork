class CreditCard < ActiveMerchant::Billing::CreditCard
  TYPES = [["Visa", "visa"], ["MasterCard", "master"], ["Discover", "discover"]]
  PAYPAL_TYPES = {
    "visa" => "Visa",
    "master" => "MasterCard",
    "discover" => "Discover",
    "amex" => "Amex"
  }
  
  attr_accessor :name, :billing_address, :user_id, :account_id, :website
  attr_accessor :combine_exp_date
  def to_s
    "credit_card"
  end
  
  def id
    
  end
  
  def combine_exp_date=(d)
    self.month = d[0..1].to_i
    self.year = "20#{d[2..-1]}".to_i
  end
  
  def name_on_card=(name)
    self.name = name
    if not name.blank?
      first_and_last_name = name.split(" ")
      self.first_name = first_and_last_name[0]
      self.last_name = first_and_last_name[1..-1].join(" ")
    end
  end
  
  def name_on_card
    self.name
  end
  
  def credit_card_number=(number)
    if not number.blank?
      self.number = number
    end
  end
  
  def credit_card_number
    self.number
  end
  
  def save(options = nil)
    
    ip = "127.0.0.1"
    if options
      if options[:ip]
        ip = options[:ip]
      end
    end
    begin
      purchase_options = self.billing_address.to_hash
      purchase_options[:ipaddress] = ip
      purchase_options[:ip] = ip
      response = GATEWAY.authorize(1, self, purchase_options)
      if response.success?
        tr = TransactionReference.new
        tr.reference = response.authorization
        length = self.number.length
        tr.card_number = self.number[length-4..-1]
        tr.exp_month = self.month
        tr.exp_year = self.year
        tr.name_on_card = "#{self.first_name} #{self.last_name}"
        tr.card_type = self.type
        tr.admin_user_id = options[:admin_user_id] if options[:admin_user_id]
        self.billing_address.save
        tr.address = self.billing_address
        
        tr.user_id = self.user_id
        tr.account_id = self.account_id
        tr.save
      else
        self.errors[""] = response.message
      end
    rescue Exception => e
      if self.website
        self.errors[""] = "We are experiencing problems with our merchant provider PayPal completing your transaction. We apologize for the inconvenience."
      else
        self.errors[""] = e.message
      end
    end
  end
  
  def to_hash
    if self.month < 10
      month_string = "0#{self.month}"
    else
      month_string = self.month
    end
    {
      :firstname => self.first_name,
      :lastname => self.last_name,
      :creditcardtype => PAYPAL_TYPES[self.type],
      :acct => self.number,
      :expdate => "#{month_string}#{self.year}",
      :cvv2 => self.verification_value
    }
  end
  
end