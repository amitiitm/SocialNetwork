class Crm::CrmTask < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects

  belongs_to :crm_account
  belongs_to :crm_contact
  has_one    :crm_activity
  belongs_to :user,:foreign_key => 'assigned_user_id',:class_name => 'Admin::User'

  def generate_trans_no(docu_type)
    self.trans_no = Setup::Sequence.generate_docu_no(self.trans_bk,docu_type,self.class,self.company_id)
  end

  after_create do
    Setup::Sequence.upd_book_code(self.trans_bk,'CRMTSK',self.trans_no,self.company_id)  if self.trans_bk == 'TK01' 
  end  
  
  def add_line_errors_to_header
    #  add_line_item_errors(production_requests)
  end

  def fill_default_header_values 
    self.trans_flag ||= 'A' 
    self.trans_bk = 'TK01'
  end
end
