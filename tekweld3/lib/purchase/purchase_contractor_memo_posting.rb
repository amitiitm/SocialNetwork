
module Purchase::PurchaseContractorMemoPosting
  ## NEWLY ADDED FOR PURCHASE POSTING FROM CONTRACTOR MEMO##
  def run_purchase_posting_for_cont_memo()
    ref_lines = [] 
    #identify reference classes and fetch current lines and original lines
    refline_class, curr_lines, orig_lines = identify_purchase_post_classes_and_lines_for_cm()
    return if refline_class.nil?
    unpost_purchase_transaction_for_cm(refline_class, ref_lines, orig_lines)
    post_purchase_transaction_for_cm(refline_class, ref_lines, curr_lines)
    return  ref_lines
  end

  def unpost_purchase_transaction_for_cm(refline_class, ref_lines, orig_lines)
    orig_lines.each{|orig_line|
      ref_bk =  orig_line.ref_trans_bk 
      ref_no = orig_line.ref_trans_no
      company_id = orig_line.company_id
      ref_date = orig_line.ref_trans_date
      #      ref_serial_no = orig_line.ref_serial_no
      catalog_item_id = orig_line.catalog_item_id
      item_qty = orig_line.item_qty
      ref_line = ref_lines.to_ary.find { |row| row.trans_no == ref_no  and row.catalog_item_id == catalog_item_id }
      ref_line = refline_class.active.find(:first,
        :conditions=>['trans_bk =? and trans_no = ? and company_id = ? and trans_date = ?  and catalog_item_id = ?',
          ref_bk,ref_no,company_id,ref_date, catalog_item_id ]) if ref_line.nil?
      if ref_line.nil? 
        #        raise_error('Reference document not found!!!')
        add_error('Reference document not found!!!')
      else
        if ref_line.memo_qty < ref_line.clear_qty - item_qty
          #          raise_error('Check qty:- Reference quantity should be greater or equal to quantity')
          add_error('Check qty:- Reference quantity should be greater or equal to quantity')
        end
        ref_line.clear_qty = ref_line.clear_qty - item_qty
        ref_lines << ref_line if ref_lines.to_ary.find {|row| row.id == ref_line.id}.nil?
      end
    }
  end

  def post_purchase_transaction_for_cm(refline_class, ref_lines, curr_lines)
    ref_line = ActiveRecord::Base
    curr_lines.each{|curr_line|
      ref_bk =  curr_line.ref_trans_bk 
      ref_no = curr_line.ref_trans_no
      company_id = curr_line.company_id
      ref_date = curr_line.ref_trans_date
      #      ref_serial_no = curr_line.ref_serial_no
      catalog_item_id = curr_line.catalog_item_id
      item_qty = curr_line.item_qty
      ref_line = ref_lines.to_ary.find { |row| row.trans_no == ref_no  and row.catalog_item_id == catalog_item_id }
      ref_line = refline_class.active.find(:first,
        :conditions=>['trans_bk =? and trans_no = ? and company_id = ? and trans_date = ?  and catalog_item_id = ?',
          ref_bk,ref_no,company_id,ref_date, catalog_item_id ]) if ref_line.nil?
      if ref_line.nil? 
        #        raise_error('Reference number not found!!!')
        add_error('Reference number not found!!!')
      else
        if ref_line.memo_qty < ref_line.clear_qty + item_qty
          #          raise_error('Check qty:- Reference quantity should be greater or equal to quantity')
          add_error('Check qty:- Reference quantity should be greater or equal to quantity')
        end
        ref_line.clear_qty = ref_line.clear_qty + item_qty
        ref_lines << ref_line if ref_lines.to_ary.find {|row| row.id == ref_line.id}.nil?
      end
      ref_hdr = refline_class.active.find_by_trans_bk_and_trans_no_and_company_id(ref_bk,ref_no,company_id)
      ref_lines << ref_hdr  if ref_lines.to_ary.find {|row| row.id == ref_hdr.id}.nil?
    }
  end

  def identify_purchase_post_classes_and_lines_for_cm()
    case self.class.name
    when 'Purchase::PurchaseInvoice'
      case self.trans_type
      when 'C'
        refline_class = Production::ContractorMemo
        #        ref_class = Production::ContractorMemo
      end
      curr_lines = purchase_invoice_lines
      orig_lines = Purchase::PurchaseInvoiceLine.find_all_by_purchase_invoice_id(id)
    else
    end
    return refline_class, curr_lines, orig_lines
  end

  private :identify_purchase_post_classes_and_lines_for_cm, :unpost_purchase_transaction_for_cm, :post_purchase_transaction_for_cm
 
end
