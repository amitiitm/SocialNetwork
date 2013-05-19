module DiamondPurchase::DiamondPurchasePosting
  include General
  include ClassMethods
  
def run_purchase_posting()
    ref_lines = [] ; ref_hdrs = []
    #identify reference classes and fetch current lines and original lines
    ref_class, refline_class, curr_lines, orig_lines = identify_purchase_post_classes_and_lines()
    return if ref_class.nil?
    unpost_purchase_transaction(refline_class, ref_lines, orig_lines)
    post_purchase_transaction(ref_class, ref_hdrs, refline_class, ref_lines, curr_lines)
    return ref_hdrs, ref_lines
  end

  def unpost_purchase_transaction(refline_class, ref_lines, orig_lines)
    orig_lines.each{|orig_line|
      ref_bk =  orig_line.ref_trans_bk 
      ref_no = orig_line.ref_trans_no
      company_id = orig_line.company_id
      ref_date = orig_line.ref_trans_date
      ref_serial_no = orig_line.ref_serial_no
      diamond_lot_id = orig_line.diamond_lot_id
      pcs = orig_line.pcs
      wt = orig_line.wt
      ref_line = ref_lines.to_ary.find { |row| row.trans_no == ref_no and  row.serial_no == ref_serial_no and row.diamond_lot_id == diamond_lot_id }
      ref_line = refline_class.active.find(:first,
                :conditions=>['trans_bk =? and trans_no = ? and company_id = ? and trans_date = ? and serial_no = ? and diamond_lot_id = ?',
                                ref_bk,ref_no,company_id,ref_date,ref_serial_no, diamond_lot_id ]) if ref_line.nil?
      if ref_line.nil? 
        add_error('Reference document not found!!!')
      else
        if ref_line.pcs < ref_line.clear_pcs - pcs
          add_error('Check qty:- Reference quantity should be greater or equal to quantity')
        end
        if ref_line.wt < ref_line.clear_wt - wt
          add_error('Check qty:- Reference quantity should be greater or equal to quantity')
        end
        ref_line.clear_pcs = ref_line.clear_pcs - pcs
        ref_line.clear_wt = ref_line.clear_wt - wt
        ref_lines << ref_line if ref_lines.to_ary.find {|row| row.id == ref_line.id}.nil?
      end
    }
  end

  def post_purchase_transaction(ref_class, ref_hdrs, refline_class, ref_lines, curr_lines)
    ref_line = ActiveRecord::Base
    curr_lines.each{|curr_line|
      ref_bk =  curr_line.ref_trans_bk 
      ref_no = curr_line.ref_trans_no
      company_id = curr_line.company_id
      ref_date = curr_line.ref_trans_date
      ref_serial_no = curr_line.ref_serial_no
      diamond_lot_id = curr_line.diamond_lot_id
      pcs = curr_line.pcs
      wt = curr_line.wt
      ref_line = ref_lines.to_ary.find { |row| row.trans_no == ref_no and  row.serial_no == ref_serial_no and row.diamond_lot_id == diamond_lot_id }
      ref_line = refline_class.active.find(:first,
                :conditions=>['trans_bk =? and trans_no = ? and company_id = ? and trans_date = ? and serial_no = ? and diamond_lot_id = ?',
                                ref_bk,ref_no,company_id,ref_date,ref_serial_no, diamond_lot_id ]) if ref_line.nil?
      if ref_line.nil? 
        add_error('Reference number not found!!!')
      else
        if ref_line.pcs < ref_line.clear_pcs + pcs
          add_error('Check qty:- Reference quantity should be greater or equal to quantity')
        end
        if ref_line.wt < ref_line.clear_wt + wt
          add_error('Check qty:- Reference quantity should be greater or equal to quantity')
        end
        ref_line.clear_pcs = ref_line.clear_pcs + pcs
        ref_line.clear_wt = ref_line.clear_wt + wt
        ref_lines << ref_line if ref_lines.to_ary.find {|row| row.id == ref_line.id}.nil?
      end
      ref_hdr = ref_class.active.find_by_trans_bk_and_trans_no_and_company_id(ref_bk,ref_no,company_id)
      ref_hdrs << ref_hdr  if ref_hdrs.to_ary.find {|row| row.id == ref_hdr.id}.nil?
    }
  end

  def identify_purchase_post_classes_and_lines
      case self.class.name
      when 'DiamondPurchase::DiamondPurchaseInvoice'
        case self.ref_type
        when 'M'
          refline_class = DiamondPurchase::DiamondPurchaseMemoLine
          ref_class = DiamondPurchase::DiamondPurchaseMemo
        when 'D' #no need of any transactional posting as the invoice is Direct.
          return
        end
        orig_lines = DiamondPurchase::DiamondPurchaseInvoiceLine.find_all_by_diamond_purchase_id(id)
      when 'DiamondPurchase::DiamondPurchaseCredit'
        case self.ref_type
          when 'I'
          refline_class = DiamondPurchase::DiamondPurchaseInvoiceLine
          ref_class = DiamondPurchase::DiamondPurchaseInvoice
          when 'D'
            return
          end
          orig_lines = DiamondPurchase::DiamondPurchaseCreditLine.find_all_by_diamond_purchase_id(id)
      when 'DiamondPurchase::DiamondPurchaseMemoReturn'
        refline_class = DiamondPurchase::DiamondPurchaseMemoLine
        ref_class = DiamondPurchase::DiamondPurchaseMemo
        orig_lines = DiamondPurchase::DiamondPurchaseMemoReturnLine.find_all_by_diamond_purchase_id(id)
      else
      end
      curr_lines = self.diamond_purchase_lines
      return ref_class, refline_class, curr_lines, orig_lines
  end

  private :identify_purchase_post_classes_and_lines, :unpost_purchase_transaction, :post_purchase_transaction

end  
