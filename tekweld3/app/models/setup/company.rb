class Setup::Company < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General
#  require 'has_finder' 
  has_many :sequences, :class_name => 'Setup::Sequence' , :extend=>ExtendAssosiation
  has_one :default_company_store, :class_name => 'Setup::CompanyStore', :foreign_key=> 'default_store_id'
  has_many :user_companies, :class_name => 'Admin::UserCompany' , :extend=>ExtendAssosiation
#  has_finder :activecompany, :conditions => { :trans_flag => 'A' }
  
  validates_uniqueness_of   :company_cd
  
  def add_line_details(user_company_doc)
  id =  parse_xml(user_company_doc/'id') if (user_company_doc/'id').first
  user_company = user_company_lines(user_company_doc.name,id) || book_lines(user_company_doc.name,id) || nil
  user_company.apply_attributes(user_company_doc) if user_company
  user_company.fill_default_detail_values
  end
  
def user_company_lines(name,id)
  user_companies.find_or_build(id) if name == 'user_company' 
end

def book_lines(name,id)
  sequences.find_or_build(id) if name == 'sequence' 
end

def save_user_companies
  user_companies.save_line
end


def save_sequences
  sequences.save_line
end

def add_line_errors_to_header
  add_line_item_errors(user_companies)
  add_line_item_errors(sequences)
end

def fill_default_header_values
 
end

end
