module Production::LabPosting
  include General
  include ClassMethods

  def run_sales_posting()
    ref_lines = [] ; ref_hdrs = []
    #identify reference classes and fetch current lines and original lines
    ref_class, refline_class, curr_lines, orig_lines = identify_production_post_classes_and_lines()
    return if ref_class.nil?
    unpost_sales_transaction(refline_class, ref_lines, orig_lines)
    post_sales_transaction(ref_class, ref_hdrs, refline_class, ref_lines, curr_lines)
    return ref_hdrs, ref_lines
  end

  def unpost_sales_transaction(refline_class, ref_lines, orig_lines)
    orig_lines.each{|orig_line|
      ref_bk =  orig_line.ref_trans_bk 
      ref_no = orig_line.ref_trans_no
      ref_date = orig_line.ref_trans_date
      ref_serial_no = orig_line.ref_serial_no
      catalog_item_id = orig_line.catalog_item_id
      company_id = orig_line.company_id
      item_qty = orig_line.item_qty
      ref_line = ref_lines.to_ary.find { |row| row.trans_no == ref_no and  row.serial_no == ref_serial_no and row.catalog_item_id == catalog_item_id and row.company_id == company_id}
      ref_line = refline_class.active.find(:first,
                :conditions=>['trans_bk =? and trans_no = ? and company_id = ? and trans_date = ? and serial_no = ? and catalog_item_id = ?',
                                ref_bk,ref_no,company_id,ref_date,ref_serial_no, catalog_item_id ]) if ref_line.nil?
      if ref_line.nil? 
#        raise_error('Reference document not found!!!')
        add_error('Reference document not found!!!')
      else
        if ref_line.item_qty < ref_line.clear_qty - item_qty
#          raise_error('Check qty:- Reference quantity should be greater or equal to quantity')
           add_error('Check qty:- Reference quantity should be greater or equal to quantity')
        end
        ref_line.clear_qty = ref_line.clear_qty - item_qty
        ref_lines << ref_line if ref_lines.to_ary.find {|row| row.id == ref_line.id}.nil?
      end
    }
  end

  def post_sales_transaction(ref_class, ref_hdrs, refline_class, ref_lines, curr_lines)
    ref_line = ActiveRecord::Base
    curr_lines.each{|curr_line|
      ref_bk =  curr_line.ref_trans_bk 
      ref_no = curr_line.ref_trans_no
      ref_date = curr_line.ref_trans_date
      ref_serial_no = curr_line.ref_serial_no
      catalog_item_id = curr_line.catalog_item_id
      company_id = curr_line.company_id
      item_qty = curr_line.item_qty
      ref_line = ref_lines.to_ary.find { |row| row.trans_no == ref_no and  row.serial_no == ref_serial_no and row.catalog_item_id == catalog_item_id }
      ref_line = refline_class.active.find(:first,
                :conditions=>['trans_bk = ? and trans_no = ? and company_id = ? and trans_date = ? and serial_no = ? and catalog_item_id = ?',
                                ref_bk,ref_no,company_id,ref_date,ref_serial_no, catalog_item_id ]) if ref_line.nil?
      if ref_line.nil? 
#        raise_error('Reference number not found!!!')
        add_error('Reference number not found!!!')
      else
        if ref_line.item_qty < ref_line.clear_qty + item_qty
#          raise_error('Check qty:- Reference quantity should be greater or equal to quantity')
          add_error('Check qty:- Reference quantity should be greater or equal to quantity')
        end
        ref_line.clear_qty = ref_line.clear_qty + item_qty
        ref_lines << ref_line if ref_lines.to_ary.find {|row| row.id == ref_line.id}.nil?
      end
      ref_hdr = ref_class.active.find_by_trans_bk_and_trans_no_and_company_id(ref_bk,ref_no,company_id)
      ref_hdrs << ref_hdr  if ref_hdrs.to_ary.find {|row| row.id == ref_hdr.id}.nil?
    }
  end

  def identify_production_post_classes_and_lines
      case self.class.name
        when 'Production::LabMemo'
        curr_lines = lab_memo_lines
        orig_lines = Production::LabMemoLine.find_all_by_lab_memo_id(id)
         when 'Production::LabMemoReturn'
        refline_class = Production::LabMemoLine
        ref_class = Production::LabMemo
        curr_lines = lab_memo_return_lines
        orig_lines = Production::LabMemoReturnLine.find_all_by_lab_memo_return_id(id)
      when 'Sales::SalesInvoice'
        case self.trans_type
        when 'O'
          refline_class = Sales::SalesOrderLine
          ref_class = Sales::SalesOrder
        when 'M'
          refline_class = Sales::SalesMemoLine
          ref_class = Sales::SalesMemo
        when 'D' #no need of any transactional posting as the invoice is Direct.
          return
        end
        curr_lines = sales_invoice_lines
        orig_lines = Sales::SalesInvoiceLine.find_all_by_sales_invoice_id(id)
      when 'Sales::SalesMemo'
        refline_class = Sales::SalesOrderLine
        ref_class = Sales::SalesOrder
        curr_lines = sales_memo_lines
        orig_lines = Sales::SalesMemoLine.find_all_by_sales_memo_id(id)
      when 'Sales::SalesCreditInvoice'
        case self.trans_type
        when 'I'
        refline_class = Sales::SalesInvoiceLine
        ref_class = Sales::SalesInvoice
        when 'D'
          return
        end
        curr_lines = sales_credit_invoice_lines
        orig_lines = Sales::SalesCreditInvoiceLine.find_all_by_sales_credit_invoice_id(id)
      when 'Sales::SalesMemoReturn'
        refline_class = Sales::SalesMemoLine
        ref_class = Sales::SalesMemo
        curr_lines = sales_memo_return_lines
        orig_lines = Sales::SalesMemoReturnLine.find_all_by_sales_memo_return_id(id)
      when 'Sales::SalesOrderCancel'
        refline_class = Sales::SalesOrderLine
        ref_class = Sales::SalesOrder
        curr_lines = sales_order_cancel_lines
        orig_lines = Sales::SalesOrderCancelLine.find_all_by_sales_order_cancel_id(id)
      else
      end
      return ref_class, refline_class, curr_lines, orig_lines
  end

  private :identify_production_post_classes_and_lines, :unpost_sales_transaction, :post_sales_transaction

end  
