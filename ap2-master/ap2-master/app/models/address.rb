class Address < ActiveRecord::Base
  belongs_to :user
  has_one :tmp_credit_card_info
  
  has_many :transaction_references
  has_many :orders
  before_save :upcase_state
  
  validates_presence_of :address1,    :message => "Address1 can't be blank"
  validates_presence_of :city,        :message => "City can't be blank"
  validates_presence_of :zipcode,     :message => "Zip Code can't be blank"
  validates_presence_of :state,       :message => "State can't be blank"

  validates_numericality_of :zipcode,
    :unless => Proc.new { |address| address.zipcode.blank? }, :message => "Please enter a valid zipcode number"
  
  def to_s
    "address"
  end
  def upcase_state
    self.state = self.state.upcase unless self.state.blank?
  end
  
  def to_hash
    {
      :street   => self.address1,
      :street2  => self.address2 || "",
      :city     => self.city,      
      :state => self.state,
      :countrycode => "US",
      :zip => self.zipcode      
    }
  end
  
  STATES = [
    ['',''],
    ['Alabama', 'AL'],
    ['Alaska', 'AK'],
    ['Arizona', 'AZ'],
    ['Arkansas', 'AR'],
    ['California', 'CA'],
    ['Colorado', 'CO'],
    ['Connecticut', 'CT'],
    ['Delaware', 'DE'],
    ['Dist of Columbia', 'DC'],
    ['Florida', 'FL'],
    ['Georgia', 'GA'],
    ['Hawaii', 'HI'],
    ['Idaho', 'ID'],
    ['Illinois', 'IL'],
    ['Indiana', 'IN'],
    ['Iowa', 'IA'],
    ['Kansas', 'KS'],
    ['Kentucky', 'KY'],
    ['Louisiana', 'LA'],
    ['Maine', 'ME'],
    ['Maryland', 'MD'],
    ['Massachusetts', 'MA'],
    ['Michigan', 'MI'],
    ['Minnesota', 'MN'],
    ['Mississippi', 'MS'],
    ['Missouri', 'MO'],
    ['Montana', 'MT'],
    ['Nebraska', 'NE'],
    ['Nevada', 'NV'],
    ['New Hampshire', 'NH'],
    ['New Jersey', 'NJ'],
    ['New Mexico', 'NM'],
    ['New York', 'NY'],
    ['North Carolina', 'NC'],
    ['North Dakota', 'ND'],
    ['Ohio', 'OH'],
    ['Oklahoma', 'OK'],
    ['Oregon', 'OR'],
    ['Pennsylvania', 'PA'],
    ['Rhode Island', 'RI'],
    ['South Carolina', 'SC'],
    ['South Dakota', 'SD'],
    ['Tennessee', 'TN'],
    ['Texas', 'TX'],
    ['Utah', 'UT'],
    ['Vermont', 'VT'],
    ['Virginia', 'VA'],
    ['Washington', 'WA'],
    ['West Virginia', 'WV'],
    ['Wisconsin', 'WI'],
    ['Wyoming', 'WY']
  ]  
end
