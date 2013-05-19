class GeneralLedger::GlTransactionCrud < ActiveRecord::Base
include General

def self.list_journals(doc)
  criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
  condition = " (company_id=#{criteria.company_id} )AND
                        (trans_no between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or trans_no in ('#{criteria.multiselect1}'))) AND
                        nvl(trans_date,'1990-01-01 00:00:00') between '#{criteria.dt1}' and '#{criteria.dt2}' AND
                        (account_period_code between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or account_period_code in ('#{criteria.multiselect2}')))  AND
                        (trans_type between '#{criteria.str5}' and '#{criteria.str6}' AND  (0 =#{criteria.multiselect3.length} or trans_type in ('#{criteria.multiselect3}')))
                         "
  condition = convert_sql_to_db_specific(condition)                       
#  GeneralLedger::GlTransaction.active.find(:all,
#       :conditions => [condition ,criteria.company_id,criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
#                           criteria.dt1,criteria.dt2,
#                           criteria.str3, criteria.str4, criteria.multiselect2.length,criteria.multiselect2,                                          
#                           criteria.str5, criteria.str6,criteria.multiselect3.length,criteria.multiselect3]              
#  ) 
  GeneralLedger::GlTransaction.find_by_sql ["select CAST( (select(select id,trans_type,trans_bk,trans_no,trans_date,account_period_code from gl_transactions where
                                          trans_flag = 'A' AND
                                          #{condition}
                                          FOR XML PATH('gl_transaction'),type,elements xsinil)FOR XML PATH('gl_transactions')) AS xml) as xmlcol ",
#                                          criteria.company_id,criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
#                                          criteria.dt1,criteria.dt2,
#                                          criteria.str3, criteria.str4, criteria.multiselect2.length,criteria.multiselect2,
#                                          criteria.str5, criteria.str6,criteria.multiselect3.length,criteria.multiselect3
                                ]      
 end
 
def self.show_journals(journal_id)
  GeneralLedger::GlTransaction.find_all_by_id(journal_id)
end

def self.create_journals(doc)
  journals = [] 
  journal_doc= (doc/:gl_transactions/:gl_transaction).first
  journal = create_journal(journal_doc)
  if journal
    journals <<  journal 
  end
  journals
end

def self.create_journal(journal_doc)
  journal = add_or_modify(journal_doc) 
  return  if !journal
  return journal if !journal.errors.empty?
  journal.generate_trans_no if journal.new_record?
#  journal.apply_header_fields_to_lines  
  journal.gl_transaction_lines.applied_lines.each{|journal_line|
    journal_line.copy_header_fields_to_lines(journal.trans_no,journal.trans_bk,journal.trans_date,journal.company_id) #if journal_line.new_record?
  }
  gl_postings = journal.create_gl_postings 
  save_proc = Proc.new{
    journal.validate_journal    
    if journal.new_record?
      journal.save!
      journal.update_trans_no      
    else
      journal.save! 
      journal.gl_transaction_lines.save_line
    end       
    GeneralLedger::GlPosting.post_gl_transactions(gl_postings) if gl_postings   
  }
  journal.save_transaction(&save_proc)
  return journal
end
  
def self.add_or_modify(doc)  
  id =  parse_xml(doc/'id') if (doc/'id').first  
  journal = GeneralLedger::GlTransaction.find_or_create(id) 
  return if !journal
  return journal if journal.view_only
  journal.apply_attributes(doc) 
  journal.trans_bk = 'JD01'
  journal.docu_type = 'FAGLDT'
  journal.fill_default_header_values()      
  journal.max_serial_no = journal.gl_transaction_lines.active.maximum_serial_no
  journal.build_lines(doc/:gl_transaction_lines/:gl_transaction_line)   
  return journal 
end

end
