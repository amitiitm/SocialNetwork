class Friend
  
  attr_accessor :name, :email, :message
  attr_accessor :errors
  
  def initialize()
    self.errors = Hash.new
  end
  
  def initialize(params)
    self.errors = Hash.new
    self.name = params[:name]
    self.email = params[:email]
    self.message = params[:message]
  end
  
  def valid?
    if self.name.blank?
      self.errors["name"] = "Friends name can't be blank"
    end
    if self.email.blank?
      self.errors["email"] = "Friends email address can't be blank"
    end
    
    (self.errors.size == 0)
  end
end