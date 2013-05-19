class Crm::CrmAccount < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects
  #include Accounts::RecevableLib
  #include Accounts::Invoice

  #  attr_accessor  :max_serial_no, :parent_code, :name, :city, :state, :zip, :phone1, :contact1, :docu_type
  validates :name,:presence => true
  validates_uniqueness_of :account_number
  validates_numericality_of  :annual_revenue, :credit_limit, :less_than_or_equal_to=>999999999.99,:allow_nil=>true 
  
  
  belongs_to :parent_account,  :class_name => "CrmAccount",
    :foreign_key => "parent_account_id"
  belongs_to :crm_account_category
  has_many :crm_addresses,:class_name =>'CrmAddress',:foreign_key => 'address_for_id', :dependent => :destroy, :extend=>ExtendAssosiation 
  has_many :crm_tasks, :dependent => :destroy, :extend=>ExtendAssosiation 
  has_many :crm_contacts, :dependent => :destroy, :extend=>ExtendAssosiation 
  has_many :crm_activities, :dependent => :destroy, :extend=>ExtendAssosiation 
  has_many :crm_opportunities, :dependent => :destroy, :extend=>ExtendAssosiation 
  
  def add_line_details(line_doc)
    id =  parse_xml(line_doc/'id') if (line_doc/'id').first
    line = other_addresses(line_doc.name,id) ||tasks(line_doc.name,id) ||contacts(line_doc.name,id) ||opportunities(line_doc.name,id)|| activities(line_doc.name,id) ||nil
    line.apply_attributes(line_doc) if line
    if line.new_record? and line_doc.name == 'crm_task'
      line.fill_default_header_values() 
      line.generate_trans_no('CRMTSK') 
    end
    ## CRM activities are not saving from arm accounts in futre if it saves then for generating trans_no uncomment this
    if line.new_record? and line_doc.name == 'crm_activity'
      line.fill_default_header_values() 
      line.generate_trans_no('CRMACT') 
    end
  end
 
  def other_addresses(name,id)
    crm_addresses.find_or_build(id) if name == 'crm_address'
  end

  def tasks(name,id)
    crm_tasks.find_or_build(id) if name == 'crm_task'
  end
 
  def contacts(name,id)
    crm_contacts.find_or_build(id) if name == 'crm_contact'
  end

  def opportunities(name,id)
    crm_opportunities.find_or_build(id) if name == 'crm_opportunity'
  end

  def activities(name,id)
    crm_activities.find_or_build(id) if name == 'crm_activity'
  end
 
  def save_lines
    crm_addresses.save_line 
    crm_tasks.save_line 
    crm_contacts.save_line 
    crm_activities.save_line 
    crm_opportunities.save_line 
  end

  def add_line_errors_to_header
    add_line_item_errors(crm_addresses)
    add_line_item_errors(crm_tasks) 
    add_line_item_errors(crm_contacts)
    add_line_item_errors(crm_activities) 
    add_line_item_errors(crm_opportunities) 
  end
  
end
