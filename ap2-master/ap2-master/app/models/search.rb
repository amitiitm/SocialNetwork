class Search
  attr_accessor :search_type
  attr_accessor :search
  
  def initialize(search_params)
    self.search_type = search_params[:search_type]
    self.search = search_params[:search]    
  end
  
  def account_id    
    search_result
  end
    
  private
  def search_result
    if self.search_type == "1"
      search_by_account
    elsif self.search_type == "2"
      search_by_phone
    else
      false
    end
  end
  
  def search_by_account
    account = Account.find(:first, :conditions => {:number => self.search})
    if account
      account.id
    else
      false
    end
  end
  
  def search_by_phone    
    phone = Phone.find(:first, :conditions => ["number like ?", "%#{self.search}%"])
    if phone
      phone.account.id
    else
      false
    end
  end
  
end