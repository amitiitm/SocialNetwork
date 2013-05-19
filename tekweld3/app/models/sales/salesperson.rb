class Sales::Salesperson < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General

  #  has_many :salesperson_equipments, :class_name => 'Sales::SalespersonEquipment' , :extend=>ExtendAssosiation
  has_many :customer_salespeople,:class_name => 'Customer::CustomerSalesperson' , :dependent => :destroy, :extend=>ExtendAssosiation
  validates_uniqueness_of :code, :message=>'code is dupilcte' 
  
  def add_line_details(line_doc)
    id =  parse_xml(line_doc/'id') if (line_doc/'id').first
    line = salespeople(line_doc.name,id) || nil
    line.apply_attributes(line_doc) if line
    #    line.salesperson_code = self.code if (line and line_doc.name == 'customer_salesperson')
    line.fill_default_detail_values if line
  end

  #  def equipments(name,id)
  #    salesperson_equipments.find_or_build(id) if name == 'salesperson_equipment' 
  #  end

  def salespeople(name,id)
    customer_salespeople.find_or_build(id)  if name == 'customer_salesperson'
  end

  def save_lines
    #    salesperson_equipments.save_line 
    customer_salespeople.save_line
  end

  def add_line_errors_to_header
    #    add_line_item_errors(salesperson_equipments)
    add_line_item_errors(customer_salespeople) if customer_salespeople
  end

  def fill_default_header_values
  end

  def apply_header_fields_to_lines()
  end

  def apply_line_fields_to_header() 
  end

end
