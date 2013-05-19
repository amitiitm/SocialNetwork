module General
  MAX_SERIAL_NO = 101
  INVOICE_GL_SERIAL_NO = 301
  INVOICE_DTL_GL_SERIAL_NO = 201
  INVOICE_MODULE_CODE = 'FAAR'
  CUSTOMER_RECEIPT_MODULE_CODE = 'FAXX'

  #  SALES_INVOICE_MODULE_CODE = 'SAOI' #defined by purva
  #  SALES_INVOICE_GL_SERIAL_NO = 401 #defined by purva

  CUSTOMER_RECEIPT_GL_SERIAL_NO = 201
  CUSTOMER_RECEIPT_DTL_GL_SERIAL_NO = 101
  CUSTOMER_RECEIPT_DTL_DEBIT_SERIAL_NO = 203
  CUSTOMER_RECEIPT_DTL_CREDIT_SERIAL_NO = 303
  CUSTOMER_RECEIPT_DTL_DISCOUNT_SERIAL_NO = 103

  PURCHASE_INVOICE_MODULE_CODE = 'PUOI'
  PURCHASE_INVOICE_GL_SERIAL_NO = 501

  PURCHASE_PAYMENT_GL_SERIAL_NO = 201
  PURCHASE_PAYMENT_DTL_GL_SERIAL_NO = 101
  PURCHASE_PAYMENT_DTL_DEBIT_SERIAL_NO = 203
  PURCHASE_PAYMENT_DTL_CREDIT_SERIAL_NO = 303
  PURCHASE_PAYMENT_DTL_DISCOUNT_SERIAL_NO = 103

  SALES_INVOICE_MODULE_CODE = 'SAOI'
  SALES_INVOICE_GL_SERIAL_NO = 501

  BANK_GL_SERIAL_NO = 101
  JOURNAL_MODULE_CODE = 'FAGL'
  PAYMENTS = 'PAYM'
  DEPOSITS = 'DEPS'
  BANKTRANSFER  = 'TRFR'

  INVN_RECEIVE = 'R'
  INVN_ISSUE = 'I'
  INVN_TRANSFER = 'T'
  INVN_MEMO_NO = 'N'
  INVN_MEMO_YES = 'Y'

  TRANS_TYPE_MEMO = 'M'
  TRANS_TYPE_ORDER = 'O'
  TRANS_TYPE_DIRECT = 'D'

  ### PROMO-ERP ORDERS TRANS TYPES ###
  TRANS_TYPE_REGULAR_ORDER = 'S'
  TRANS_TYPE_REORDER = 'E'
  TRANS_TYPE_SAMPLE_ORDER = 'P'
  TRANS_TYPE_VIRTUAL_ORDER = 'V'
  TRANS_TYPE_PREPRODUCTION_ORDER = 'F'
  TRANS_TYPE_QUOTATION_ORDER = 'Q'

  ### PROMO ORDER DEFAULT SHIP FROM TYPE ###
  SHIP_FROM_COMPANY = 'C'
  SHIP_FROM_VENDOR = 'V'


  ### PROMO-ERP ORDERS PRODUCTION TYPES ###
  CATALOG_ATTRIBUTE_CODE = 'IMPRINTTYPE'
  ATTRIBUTE_VALUE_DIRECT = 'DIRECT'
  ATTRIBUTE_VALUE_DIGITEK = 'DIGITEK'
  ATTRIBUTE_VALUE_DECAL = 'DECAL'
  ATTRIBUTE_VALUE_EMBROIDERY = 'EMBROIDERY'
  ATTRIBUTE_VALUE_LASER_ETCHED = 'LASERETCHED'
  ATTRIBUTE_VALUE_FULLCOLOR = 'FULLCOLOR'
  ATTRIBUTE_VALUE_DOCUCOLOR = 'DOCUCOLOR'
  ATTRIBUTE_VALUE_PAD = 'PAD'
  ATTRIBUTE_VALUE_WATER = 'WATER'
  WORKFLOW_WATER = 'WATER'
  WORKFLOW_EMBROIDERY = 'EMBROIDERY'
  WORKFLOW_PAD = 'PAD'
  WORKFLOW_DOCUCOLOR = 'DOCUCOLOR'
  WORKFLOW_DIRECT_DECAL_DIGITEK = 'DIRECTPRINT/DECAL/DIGITEK'

  ### PROMO-ERP RE-ORDER TYPES ###
  REORDER_TYPE1 = 'Exact'
  REORDER_TYPE2 = 'Change No Art'
  REORDER_TYPE3 = 'Change w / Art'

  ### PROMO-ERP ORDER STATUS ###
  NEW_ORDER = 'NEW ORDER'
  ORDER_ANSWERED = 'ORDER ANSWERED'
  ORDER_PICKED = 'ORDER PICKED'
  ORDER_REASSIGNED_FOR_ENTRY = 'ORDER REASSIGNED FOR ENTRY'
  ORDER_QUERIED = 'ORDER-QUERIED'
  ENTRY_COMPLETED = 'ENTRY COMPLETED'
  QC_COMPLETE = 'QC COMPLETE'
  STITCHES_REJECTED_REDESIGN_ARTWORK = 'STITCHES REJECTED REDESIGN ARTWORK'
  STITCHES_REJECTED_CHANGE_LAYOUT = 'STITCHES REJECTED CHANGE LAYOUT'
  REJECTED_FROM_PRINT = 'REJECTED FROM PRINT'
  PARTIAL_PACKAGING = 'PARTIAL PACKAGING'
  PACKAGING_COMPLETED = 'PACKAGING COMPLETED'
  PARTIAL_SHIPPED = 'PARTIAL SHIPPED'
  SHIPPED = 'SHIPPED'
  SHIPPED_TO_VENDOR = 'SHIPPED TO VENDOR'
  PARTIAL_INVOICED = 'PARTIAL INVOICED'
  INVOICED = 'INVOICED'
  ORDER_COMPLETED = 'ORDER COMPLETED'
  IMPOSITION_COMPLETE = 'IMPOSITION COMPLETE'
  PRINT_COMPLETE = 'PRINT COMPLETE'
  CUTTING_COMPLETE = 'CUTTING COMPLETE'
  FILE_SEND_FOR_STITCH_ESTIMATION = 'FILE SEND FOR STITCH ESTIMATION'
  DIGI_ESTIMATION_RECEIVED = 'DIGI ESTIMATION RECEIVED'
  STITCHES_APPROVED_BY_CUSTOMER = 'STITCHES APPROVED BY CUSTOMER'
  STITCHES_REJECTED_FOR_RE_ESTIMATION = 'STITCHES REJECTED FOR RE-ESTIMATION'
  SENT_DIGITIZING = 'SENT DIGITIZING'
  DIGITIZED_FILE_RECEIVED = 'DIGITIZED FILE RECEIVED'
  FILM_COMPLETE = 'FILM COMPLETE'
  STITCH_DONE = 'STITCH DONE'
  PRODUCTION_DONE = 'PRODUCTION DONE'
  ORDER_CANCELLED = 'ORDER CANCELLED'

  ### PROMO-ERP ARTWORK STATUS ###
  NOT_APPLICABLE = 'NOT APPLICABLE'
  WAITING_ARTWORK = 'WAITING ARTWORK'
  ARTWORK_RECEIVED = 'ARTWORK RECEIVED'
  ARTWORK_ANSWERED = 'ARTWORK ANSWERED'
  PROOF_IN_PROGRESS = 'PROOF IN PROGRESS'
  ARTWORK_QUERIED = 'ARTWORK-QUERIED'
  READY_FOR_INTERNAL_PROOFING = 'READY FOR INTERNAL PROOFING'
  REJECTED_FROM_IMPOSITION = 'REJECTEDFROMIMPOSITION'
  REJECTED_FROM_FILM = 'REJECTED FROM FILM'
  ARTWORK_QC = 'ARTWORK QC'
  SENT_TO_CUSTOMER = 'SENT TO CUSTOMER'
  PROOF_APPROVED = 'PROOF APPROVED'
  PROOF_REJECTED = 'PROOF REJECTED'
  
  ### PROMO-ERP ACKNOWLEDGEMENT STATUS ###
  NOT_SENT = 'NOT SENT'
  SENT = 'SENT'

  ### PROMO-ERP ACCOUNTING STATUS ###
  CLEAR = 'CLEAR'
  CREDIT_CARD = 'CREDIT CARD'
  
  ### PROMO-ERP PAYMENT STATUS ###
  OVER_CREDIT_LIMIT = 'OVER CREDIT LIMIT'
  PAY_ISSUE = 'PAY ISSUE'
  CREDIT_AUTHORIZED = 'CREDIT AUTHORIZED'
  CC_AUTHORIZED = 'CC AUTHORIZED'
  PAYMENT_AUTHORIZATION_FAILED = 'PAYMENT AUTHORIZATION FAILED'
  PAYMENT_CAPTURED = 'PAYMENT CAPTURED'
  PAYMENT_CAPTURED_FAILED = 'PAYMENT CAPTURED FAILED'
  CC_AUTHORIZED_AND_CAPTURED = 'CC AUTHORIZED AND CAPTURED'
  PAYMENT_AUTHORIZATION_AND_CAPTURED_FAILED = 'PAYMENT AUTHORIZATION AND CAPTURED FAILED'
  CC_RELEASED = 'CC RELEASED'
  PAYMENT_RELEASE_FAILED = 'PAYMENT RELEASE FAILED'





  def self.included(base) #:nodoc:
    super
    base.extend(ClassMethods)
  end

  module ClassMethods
    require 'chronic'
    require 'parseexcel'

    def is_valid_date?(datestring)
      !Chronic.parse(datestring).nil?
    end

    def parse_xml(objstring)
      objstring.first.innerHTML   if objstring.first
    end

    def nulltozero( numeric_field)
      numeric_field || 0
    end

    def nulltoblank(string_field)
      string_field || ''
    end

    def dateformat(datestring,formatstring)
      date_array = Date._parse(datestring.to_s, true).values_at(:year,  :mon, :mday, :hour, :min, :sec, :zone, :wday)
      formatstring_ymd?(formatstring,date_array) || formatstring_mdy?(formatstring,date_array) || formatstring_dmy(date_array)
    end

    def formatstring_ymd?(formatstring,date_array)
      DateTime.new(date_array[0], date_array[1], date_array[2]) if formatstring == 'ymd'
    end

    def formatstring_mdy?(formatstring,date_array)
      DateTime.new(date_array[1], date_array[2], date_array[0]) if formatstring == 'mdy'
    end

    def formatstring_dmy(date_array)
      DateTime.new(date_array[2], date_array[1], date_array[0])
    end

    #flexible date format
    def convert_string_to_datetime(datetimestring,format)
      date_array = ParseDate.parsedate(datetimestring.to_s, true)
      case format
      when 'dd/mm/yyyy'
        formated_date = DateTime.new(date_array[0], date_array[2], date_array[1])
      when 'mm/dd/yyyy'
        formated_date = DateTime.new(date_array[0], date_array[2], date_array[1])
      when 'yyyy/mm/dd'
      when 'standard'
        formated_date = DateTime.new(date_array[0], date_array[1], date_array[2])
        formated_date
      end
    end

    def isnill(id)
      (id.empty? or id.to_i == 0) ? :true : :false
    end

    def is_blank_id?(obj_id)
      obj_id ? (obj_id.empty? or obj_id.to_i == 0) : :true
    end

    def string_to_decimal(numeric_field)
      return 0 if numeric_field.nil?
      numeric_field.is_a?(String) ? numeric_field.to_d : numeric_field
    end

    def string_to_integer(numeric_field)
      return 0 if numeric_field.nil?
      numeric_field.is_a?(String) ? numeric_field.to_i : numeric_field
    end

    def voucher_no_from_trans_no_bk(trans_bk,trans_no)
      return trans_bk +  trans_no
    end

    def trans_bk_no_from_voucher_no(voucher_no)
      #  voucehr_no_length = voucher_no.strip.length
      return voucher_no[0,4].to_s, voucher_no[4,"#{voucher_no.strip.length}".to_i].to_s
    end

    def relativedate(old_date ,no_of_days)
      old_date + nulltozero(no_of_days.to_i).days
    end

    def credit_invoice?(trans_type)
      (trans_type =='C' || trans_type == 'CA') ? true : false
    end

    def receipts?(trans_type)
      (trans_type =='R' || trans_type == 'A' ) ? true : false
    end

    def payments?(trans_type)
      (trans_type =='P' || trans_type == 'A' ) ? true : false
    end

    def invoice?(trans_type)
      trans_type =='I' ? true : false
    end

    def memo?(trans_type)
      trans_type =='M' ? true : false
    end

    def apply?(trans_type)
      (trans_type =='A' || trans_type =='CA')  ? true : false
    end

    def customer?(accounts_module)
      accounts_module =='C' ? true : false
    end

    def vendor?(accounts_module)
      accounts_module =='V' ? true : false
    end


    def bank_gl_transaction?(account_flag)
      account_flag =='G' ? true : false
    end

    def bank_customer_transaction?(account_flag)
      account_flag =='C' ? true : false
    end

    def bank_vendor_transaction?(account_flag)
      account_flag =='V' ? true : false
    end

    def bank_transfer?(type_flag)
      (type_flag == 'B' || type_flag == "#{BANKTRANSFER}") ? true : false
    end

    def bank_payments?(type_flag)
      type_flag == "#{PAYMENTS}" ? true : false
    end

    def bank_deposits?(type_flag)
      type_flag ==  "#{DEPOSITS}" ? true : false
    end

    def vendorinvoice?(invoice_type)
      invoice_type =='Vendor::VendorInvoice' ? true : false
    end

    def customerinvoice?(invoice_type)
      invoice_type =='Customer::CustomerInvoice' ? true : false
    end

    def vendorpayment?(type)
      type =='Vendor::VendorPayment' ? true : false
    end

    def customerreceipt?(type)
      type =='Customer::CustomerReceipt' ? true : false
    end

    #multi adapter change
    def convert_sql_to_db_specific(sql)
      #      sql.gsub!("isnull(","nvl(")  if ActiveRecord::Base.retrieve_connection.class.to_s.match('IBM_DBAdapter')
      sql.gsub!("nvl(","isnull(")  #if ActiveRecord::Base.retrieve_connection.class.to_s.match('SQLServerAdapter')
      sql.gsub!("concat","dbo.concat")  #if ActiveRecord::Base.retrieve_connection.class.to_s.match('SQLServerAdapter')
      #      sql.gsub!("CURRENT_TIMESTAMP","CURRENT TIMESTAMP")  if ActiveRecord::Base.retrieve_connection.class.to_s.match('IBM_DBAdapter')
      sql.gsub!("CURRENT TIMESTAMP","CURRENT_TIMESTAMP")  #if ActiveRecord::Base.retrieve_connection.class.to_s.match('SQLServerAdapter')
      sql.gsub!("||","+")  #if ActiveRecord::Base.retrieve_connection.class.to_s.match('SQLServerAdapter')
      sql.gsub!("TRANSLATE","dbo.translate")  #if ActiveRecord::Base.retrieve_connection.class.to_s.match('SQLServerAdapter')
      sql
    end
    def find_datetime_difference(start_date_time, end_date_time)
      datetime_hash = Time.diff(start_date_time, end_date_time)
      return datetime_hash
    end

  end
end
