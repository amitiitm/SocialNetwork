module Sales::SalesGlPosting
  
  class Posting
    include General
    include ClassMethods
    
    def create_gl_postings(object)
      ar_account_id, shipping_account_id, discount_account_id, salestax_account_id, default_account_id , insurance_account_id , other_account_id = fetch_gl_account_for_sales()
      gl_postings = []
      dtl_serial_no = SALES_INVOICE_GL_SERIAL_NO
      gl_postings << post_net_amt(dtl_serial_no, ar_account_id, object) if nulltozero(object.net_amt) != 0 
      if  nulltozero(object.tax_amt) != 0 and salestax_account_id
        dtl_serial_no += 1
        gl_postings << post_salestax_amt(dtl_serial_no, salestax_account_id, object) 
      end
      if  nulltozero(object.discount_amt) != 0 and discount_account_id
        dtl_serial_no += 1
        gl_postings << post_discount_amt(dtl_serial_no, discount_account_id, object)
      end
      if  nulltozero(object.ship_amt) != 0 and shipping_account_id
        dtl_serial_no += 1
        gl_postings << post_shipping_amt(dtl_serial_no, shipping_account_id, object)
      end
      if  nulltozero(object.other_amt) != 0 and other_account_id #default acc change to other
        dtl_serial_no += 1
        gl_postings << post_other_amt(dtl_serial_no, other_account_id, object)
      end
      if  nulltozero(object.insurance_amt) != 0 and insurance_account_id
        dtl_serial_no += 1
        gl_postings << post_insurance_amt(dtl_serial_no, insurance_account_id, object)
      end
      post_item_amt(dtl_serial_no, default_account_id, object).each{|li| gl_postings << li}
      gl_postings
    end

    def fetch_gl_account_for_sales()
      glsetup = GeneralLedger::GlSetup.find(:first)
      ar_account_id = glsetup.ar_account_id
      shipping_account_id = glsetup.shipping_sales_account_id 
      discount_account_id = glsetup.discount_sales_account_id 
      salestax_account_id = glsetup.salestax_sales_account_id 
      default_account_id = glsetup.default_sales_account_id 
      #newly added
      insurance_account_id = glsetup.insurance_sales_account_id 
      other_account_id = glsetup.other_sales_account_id 
      return ar_account_id, shipping_account_id, discount_account_id, salestax_account_id, default_account_id , insurance_account_id ,other_account_id
    end

    def post_net_amt(dtl_serial_no, ar_account_id, object)
      #      credit_amt = nulltozero(object.net_amt)
      #      debit_amt = 0
      debit_amt = nulltozero(object.net_amt)
      credit_amt = 0
      gl_posting = fill_gl_posting_for_invoice(object,ar_account_id, dtl_serial_no, debit_amt, credit_amt)
      gl_posting
    end

    def post_salestax_amt(dtl_serial_no, salestax_account_id, object)
      #      debit_amt = object.tax_amt
      #      credit_amt = 0
      credit_amt = object.tax_amt
      debit_amt = 0
      gl_posting = fill_gl_posting_for_invoice(object,salestax_account_id, dtl_serial_no, debit_amt, credit_amt)	
      gl_posting
    end

    def post_discount_amt(dtl_serial_no, discount_account_id, object )
      #      credit_amt = object.discount_amt
      #      debit_amt = 0
      debit_amt = object.discount_amt
      credit_amt = 0
      gl_posting = fill_gl_posting_for_invoice(object,discount_account_id, dtl_serial_no, debit_amt, credit_amt)	
      gl_posting
    end

    def post_shipping_amt(dtl_serial_no, shipping_account_id, object)
      #      debit_amt = object.ship_amt
      #      credit_amt = 0
      credit_amt = object.ship_amt
      debit_amt = 0
      gl_posting = fill_gl_posting_for_invoice(object,shipping_account_id, dtl_serial_no, debit_amt, credit_amt)	
      gl_posting
    end

    def post_other_amt(dtl_serial_no, other_account_id, object)#default acc change to other
      #      debit_amt = object.other_amt
      #      credit_amt = 0
      credit_amt = object.other_amt
      debit_amt = 0
      gl_posting = fill_gl_posting_for_invoice(object,other_account_id, dtl_serial_no, debit_amt, credit_amt)	
      gl_posting
    end
    
    def post_insurance_amt(dtl_serial_no, insurance_account_id, object)
      #      debit_amt = object.other_amt
      #      credit_amt = 0
      credit_amt = object.insurance_amt
      debit_amt = 0
      gl_posting = fill_gl_posting_for_invoice(object,insurance_account_id, dtl_serial_no, debit_amt, credit_amt)	
      gl_posting
    end
    
    def post_item_amt(dtl_serial_no, default_account_id,object)
      item_gl_postings = []
      object_lines = identify_sales_post_lines(object)
      glsetupitems = GeneralLedger::GlSetupItem.find(:all)
      #      object_lines.each{|lineitem|
      #        #get the sale account from gl_setup_item_details
      #        item_type = lineitem.item_type
      ##        item_type='I'
      #        sales_account_id = glsetupitems.to_ary.find{|line| line.item_type == item_type}.sales_account_id
      #        sales_account_id ||= default_account_id
      #        item_amt = lineitem.item_amt
      ##        debit_amt = item_amt
      ##        credit_amt = 0
      #        credit_amt = item_amt
      #        debit_amt = 0
      #        dtl_serial_no =+ 1
      #        item_gl_postings << fill_gl_posting_for_invoice(object,sales_account_id, dtl_serial_no, debit_amt, credit_amt)
      #      }
      #changed by Praman as suggested by Vivek sir
      item_types = []
      net_amt = []
      item_typ_no = 0
      item_typ_counter=0
      object_lines = object_lines.sort_by { |lineitem| lineitem[:item_type] }
      object_lines.each{|lineitem|
        if item_types[item_typ_no] != lineitem.item_type
          item_typ_no = item_typ_no + 1 if item_typ_counter>0
          item_typ_counter=item_typ_counter+1 if item_typ_no==0
          item_types[item_typ_no] = lineitem.item_type
          net_amt[item_typ_no] = lineitem.net_amt
        else
          net_amt[item_typ_no] = net_amt[item_typ_no] + lineitem.net_amt
        end
      }
      item_types.each_with_index{|item_type,index|
        sales_account_id = glsetupitems.to_ary.find{|line| line.item_type == item_type}.sales_account_id
        sales_account_id ||= default_account_id
        credit_amt = net_amt[index]
        debit_amt = 0
        dtl_serial_no =+ 1
        item_gl_postings << fill_gl_posting_for_invoice(object,sales_account_id, dtl_serial_no, debit_amt, credit_amt)
      }

      return item_gl_postings
    end

    def fill_gl_posting_for_invoice(object,gl_account_id, dtl_serial_no, debit_amt, credit_amt)
      gl_posting = GeneralLedger::GlPosting.new
      fill_gl_posting_header_for_invoice(object,gl_posting)      
      gl_posting.dtl_serial_no = dtl_serial_no
      gl_posting.gl_account_id = gl_account_id
      case object.class.name 
      when  'Sales::SalesInvoice'
        gl_posting.debit_amt = debit_amt
        gl_posting.credit_amt = credit_amt
      when   'Sales::SalesCreditInvoice'
        gl_posting.debit_amt = credit_amt
        gl_posting.credit_amt = debit_amt
      when 'PointOfSale::PosInvoice'
        gl_posting.debit_amt = debit_amt
        gl_posting.credit_amt = credit_amt
      end
      gl_posting
    end 

    def fill_gl_posting_header_for_invoice(object,gl_posting)
      gl_posting.trans_bk = object.trans_bk
      gl_posting.trans_no = object.trans_no
      gl_posting.company_id = object.company_id
      gl_posting.trans_date = object.trans_date
      gl_posting.account_period_code = object.account_period_code
      gl_posting.trans_type = 'I'
      gl_posting.description = ''
      gl_posting.post_flag = 'U'
      gl_posting.update_flag = 'V'
      gl_posting.customer_vendor_flag = 'C'
      gl_posting.customer_vendor_id = object.customer_id
      gl_posting.serial_no = SALES_INVOICE_GL_SERIAL_NO
      gl_posting.module_code = SALES_INVOICE_MODULE_CODE
    end

    def identify_sales_post_lines(object)
      current_lines = case object.class.name
      when 'Sales::SalesInvoice'
        object.sales_invoice_lines.to_ary.find_all { |line| line.trans_flag == 'A' and nulltozero(line.net_amt) != 0 }  
      when 'Sales::SalesCreditInvoice'
        object.sales_credit_invoice_lines.to_ary.find_all { |line| line.trans_flag == 'A' and nulltozero(line.net_amt) != 0 } 
        #Newly added for POS
      when 'PointOfSale::PosInvoice'
        object.pos_invoice_lines.to_ary.find_all { |line| line.trans_flag == 'A' }  
        #condition remove for net_amt can be 0
      else
      end
      current_lines
    end

    private :fetch_gl_account_for_sales, :post_net_amt, :post_salestax_amt,:post_discount_amt, :post_shipping_amt, :post_other_amt, 
      :post_item_amt, :fill_gl_posting_for_invoice, :fill_gl_posting_header_for_invoice, :identify_sales_post_lines
  end  
end  
