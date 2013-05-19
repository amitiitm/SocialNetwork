class Crm::CrmActivity < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include ClassMethods
  include GenericSelects

  belongs_to :crm_task
  belongs_to :crm_opportunity
  belongs_to :crm_account
  belongs_to :crm_contact, :conditions => { :trans_flag => 'A'}
  belongs_to :user,:foreign_key => 'performed_user_id',:class_name => 'Admin::User'


  def generate_trans_no(docu_type)
    self.trans_no = Setup::Sequence.generate_docu_no(self.trans_bk,docu_type,self.class,self.company_id)
  end

  after_create do
    if self.trans_bk == 'AT01'
      Setup::Sequence.upd_book_code(self.trans_bk,'CRMACT',self.trans_no,self.company_id)
    end
  end  

  def fill_default_header_values 
    self.trans_flag ||= 'A' 
    self.trans_bk = 'AT01'
  end
  
  def build_activity_lines(lines_doc)
    lines_doc.each{|line_doc|
      line_id =  parse_xml(line_doc/'id') if (line_doc/'id').first
      trans_no = parse_xml(line_doc/'trans_no')
      #      line = task(line_doc.name,line_id) ||opportunity(line_doc.name,line_id) ||nil
      line = task(line_doc.name,line_id) ||nil
      if line
        line.apply_attributes(line_doc)
        if line.new_record? and line_doc.name == 'crm_task' and !trans_no
          line.fill_default_header_values() 
          line.generate_trans_no('CRMTSK') 
        end
        #    self.crm_task = line
      end
    }
  end
    
  def add_line_details(line_doc)
    id =  parse_xml(line_doc/'id') if (line_doc/'id').first
    #    line = tasks(line_doc.name,id) ||opportunities(line_doc.name,id) ||nil
    line = tasks(line_doc.name,id) || nil
    line.apply_attributes(line_doc) if line
    line.fill_gl_code_name
  end
  ## COMMENT START both func task and opportunity are changed by amit bcos when we update activity
  # it is not updating crm_tasks and crm_opportunities bcos the previous logic self.crm_task returns nil
  # delete is used bcos every time a new task and opportunity is added user will see the correct data but inside
  # it is wrong so duplicate line of task and opportunity is deleted on every update of activity
  def task(name,line_id)
    if name == 'crm_task'  
      #      is_blank_id?(line_id) ? build_crm_task : self.crm_task 
      Crm::CrmTask.delete(line_id)  if line_id.to_i > 0
      build_crm_task
    end
  end
 
  #  def opportunity(name,line_id)
  #    if name == 'crm_opportunity'
  #      #      is_blank_id?(line_id) ? self.build_crm_opportunity : self.crm_opportunity
  #      Crm::CrmOpportunity.delete(line_id) if line_id.to_i > 0
  #      build_crm_opportunity
  #    end
  #  end
  ## END
  def save_lines
    crm_task.save!  if crm_task
    #    crm_opportunity.save!  if crm_opportunity
  end

  def add_line_errors_to_header
    crm_tasks = []
    crm_tasks << crm_task if crm_task
    #    crm_opportunities = []
    #    crm_opportunities << crm_opportunity if crm_opportunity
    add_line_item_errors(crm_tasks) 
    #    add_line_item_errors(crm_opportunities)
  end
end
