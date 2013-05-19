class Setup::AccountPeriod < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General
  include ClassMethods

  belongs_to:account_year
  has_many:purchase_orders, :class_name => 'PurchaseOrder::PurchaseOrder'
  has_many:purchase_invoices ,:class_name => 'PurchaseInvoice::PurchaseInvoice'
#  has_many:purchase_cancellations

def self.period_from_date(trans_dt)
  account_periods = self.find(:all,
          :conditions => ["from_date <= ? and to_date>= ? and period_flag='O'",dateformat(trans_dt,'ymd'),dateformat(trans_dt,'ymd')],
          :select => "code")
  account_period = account_periods.empty? ? Setup::AccountPeriod.new :  account_periods.first
  account_period
end

#def self.ar_period_from_date(trans_dt)
#  begin
#    account_period = self.find(:first,
#          :conditions => ["ar_frdt <= ? and ar_todt>= ?",dateformat(trans_dt,'ymd'),dateformat(trans_dt,'ymd')],
#          :select => "code")
#  Setup::AccountPeriod.new if !account_period
#  account_period
#  rescue
##      ActiveRecord::Errors
#   Setup::AccountPeriod.new
#  end
#end
#
#def self.fetch_period_from_date(trans_dt,module_type)
#  case module_type
#    when 'AR'
#      conditions = "ar_frdt <= ? and ar_todt>= ?"
#    when 'AP'
#      conditions = "ap_frdt <= ? and ap_todt>= ?"
#    when 'GL'
#      conditions = "gl_frdt <= ? and gl_todt>= ?"
#  end
#  self.find_period(trans_dt,conditions)
#end

#def self.find_period(trans_dt,conditions)
#  account_periods = self.find(:all,
#          :conditions => ["#{conditions}",dateformat(trans_dt,'ymd'),dateformat(trans_dt,'ymd')],
#          :select => "code")
#
#  account_period = account_periods.empty? ? Setup::AccountPeriod.new :  account_periods.first
#  account_period
#end
#
end
