class Production::IndigoImposition < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects


  after_create do
    Setup::Sequence.upd_book_code(self.trans_bk,'INDIMP',self.trans_no,self.company_id)  if self.trans_bk == 'IM01'
  end

  def fill_default_header_values
    self.trans_bk = 'IM01'
    self.trans_flag ||= 'A'
    self.trans_date ||= Time.now.to_date
    self.update_flag ||= 'Y'
  end
end
