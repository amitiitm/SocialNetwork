module Dbobject
  require 'has_finder'

  #  def self.included(base)
  #    base.has_finder :active, :conditions => { :trans_flag => 'A' }
  #    super
  #    base.extend(ClassMethods)
  #  end
  def self.included(base)
    base.scope :active, :conditions => { :trans_flag => 'A' }
    super
    base.extend(ClassMethods)
  end
  def apply_attributes(xml_string)
    fields = []
    fields = attribute_names
    fields.each {|field|
      if not field == 'type'
        self[field] = parse_xml(xml_string/"/#{field}") if (xml_string/"/#{field}").first
      end
    }
  end
  
  def add_line_item_errors(line_items)
    msg = 'error'
    line_items.each {|line_item|
      line_item.errors.each{|err,msg|
        errors.add(err,msg)
      }}
  end

  def build_lines(lines_doc)
    lines_doc.each { |line_doc| add_line_details(line_doc)
    }
  end
 
  def run_block(&block)
    instance_eval(&block)
  end

  def parse_xml(objstring)
    objstring.first.innerHTML   if objstring.first
  end

  def drop
    destroy if self
  end

  def add_error(message)
    errors.add('Error!! ',"#{message.to_s}")
  end

  def raise_error(message)
    errors.add('Error!!',"#{message.to_s}")
    raise
  end

  def save_master(&save_proc)
    begin
      activerecord_transaction(&save_proc)
    rescue ActiveRecord::StaleObjectError
      errors.add( 'Error' ," #{self.code} data changed : Please refresh and try again.")
    rescue Exception => exp
      self.errors.add('',"#{exp.to_s}")
    end
  end

  def activerecord_transaction(&save_proc)
    ActiveRecord::Base.transaction do
      save_proc.call
    end
  end

  def save_transaction(&save_proc)
    begin
      activerecord_transaction(&save_proc)
    rescue ActiveRecord::StaleObjectError
      #errors.add( 'Error' ," #{self.code} data changed : Please refresh and try again.")
      errors.add( 'Error' ," data changed for #{self.class}: Please refresh and try again.")
    rescue Exception => exp
      self.errors.add('',"#{exp.to_s}")
      add_line_errors_to_header 
    end
  end

  def view_only
    if !new_record? and self.update_flag == 'V'
      errors.add('This transaction is View Only. Cannot update.')
      return true
    else
      return false
    end
  end

  def copy_header_fields_to_lines(trans_no,trans_bk,trans_date,company_id)
    #  if new_record? changed on 4july2011 as to update line date also
    self.trans_no = trans_no
    self.trans_bk = trans_bk
    self.trans_date = trans_date
    self.company_id = company_id
    #  end
  end

  module ClassMethods
    def find_or_create(obj_id)
      is_blank_id?(obj_id)  ? new : find_all_by_id(obj_id).first
    end

    def is_blank_id?(obj_id)
      obj_id ? (obj_id.empty? or obj_id.to_i == 0) : :true
    end
  
    def make_view_only(trans_bk,trans_no,trans_date,company_id)
      # Change: Praman July-04-2011 Making transaction date editable and post/unpost transaction accordingly.
      #    transaction = find_by_trans_bk_no_date(trans_bk,trans_no,trans_date,company_id)
      transaction = find_by_trans_bk_no(trans_bk,trans_no)
      transaction.each{|trn|
        trn.update_attributes(:update_flag => 'V')
      }
    end

  end

end
