module DiamondSale::DiamondSalePosting
  include General
  include ClassMethods
#  
#  def unpost_saletransactions()
#    if self.id.nil?
#      return
#    end
#    lineitems = DiamondSale::DiamondSaleLine.find_all_by_diamond_sale_id(self.id)
#    lineitems.each{|lineitem|
#        ref_bk =  lineitem.ref_trans_bk
#        ref_no = lineitem.ref_trans_no
#        ref_date = lineitem.ref_trans_date
#        ref_serial_no = lineitem.ref_serial_no
#        ref_pcs = lineitem.pcs
#        ref_wt = lineitem.wt
#        if not ref_no.empty?
#          diamondlotid = lineitem.diamond_lot_id
#          ref_lineitem = DiamondSale::DiamondSaleLine.find(:first,
#                    :conditions=>['trans_bk =? and trans_no = ? and trans_date = ? and serial_no = ? and diamond_lot_id = ?',
#                                    ref_bk,ref_no,ref_date,ref_serial_no, diamondlotid ])
#          if not ref_lineitem.nil? 
#              ref_lineitem.clear_pcs = ref_lineitem.clear_pcs - ref_pcs
#              ref_lineitem.clear_wt = ref_lineitem.clear_wt - ref_wt
#              #Here saving is necessary as user may enter same memo number on 2 lines
#              ref_lineitem.save!
#          else
#            raise_error('Reference number not found')
#          end
#        end
#    }
#  end
#
#  def post_saletransactions()
#    diamond_sale_lines.applied_lines.each{| lineitem|
#        ref_bk =  lineitem.ref_trans_bk
#        ref_no = lineitem.ref_trans_no
#        ref_date = lineitem.ref_trans_date
#        ref_serial_no = lineitem.ref_serial_no
#        ref_pcs = lineitem.pcs
#        ref_wt = lineitem.wt
#        if not ref_no.empty?
#          diamondlotid = lineitem.diamond_lot_id
#          ref_lineitem = DiamondSale::DiamondSaleLine.find(:first,
#                    :conditions=>['trans_bk =? and trans_no = ? and trans_date = ? and serial_no = ? and diamond_lot_id = ?',
#                                    ref_bk,ref_no,ref_date,ref_serial_no, diamondlotid ])
#          if not ref_lineitem.nil? 
#              if ref_lineitem.pcs < ref_lineitem.clear_pcs + ref_pcs 
#                raise_error('Check Pcs:- Ref.Pcs should be greater or equal to Pcs')
#              end
#              ref_lineitem.clear_pcs = ref_lineitem.clear_pcs + ref_pcs
#              if ref_lineitem.wt < ref_lineitem.clear_wt + ref_wt 
#                raise_error('Check Wt:- Ref.Wt should be greater or equal to Wt')
#              end
#              ref_lineitem.clear_wt = ref_lineitem.clear_wt + ref_wt
#              #Here saving is necessary as user may enter same memo number on 2 lines
#              ref_lineitem.save!
#          else
#              raise_error('Reference number not found!!!')
#          end
#          #update header. do it view only
#          ref_header = DiamondSale::DiamondSale.find(:first,
#            :conditions=>['trans_bk = ? and trans_no = ? and trans_date = ? and company_id = ?
#              and update_flag != ?', ref_bk, ref_no, ref_date, self.company_id, 'V'])
#          if not ref_header.nil?
#            ref_header.update_flag = 'V'
#            ref_header.save!    
#          end
#        end
#    }
#  end
  def run_sales_posting()
    ref_lines = [] ; ref_hdrs = []
    #identify reference classes and fetch current lines and original lines
    ref_class, refline_class, curr_lines, orig_lines = identify_sales_post_classes_and_lines()
    return if ref_class.nil?
    unpost_sales_transaction(refline_class, ref_lines, orig_lines)
    post_sales_transaction(ref_class, ref_hdrs, refline_class, ref_lines, curr_lines)
    return ref_hdrs, ref_lines
  end

  def unpost_sales_transaction(refline_class, ref_lines, orig_lines)
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

  def post_sales_transaction(ref_class, ref_hdrs, refline_class, ref_lines, curr_lines)
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

  def identify_sales_post_classes_and_lines
      case self.class.name
      when 'DiamondSale::DiamondSaleInvoice'
        case self.ref_type
        when 'M'
          refline_class = DiamondSale::DiamondSaleMemoLine
          ref_class = DiamondSale::DiamondSaleMemo
        when 'D' #no need of any transactional posting as the invoice is Direct.
          return
        end
        orig_lines = DiamondSale::DiamondSaleInvoiceLine.find_all_by_diamond_sale_id(id)
      when 'DiamondSale::DiamondSaleCredit'
        case self.ref_type
        when 'I'
        refline_class = DiamondSale::DiamondSaleInvoiceLine
        ref_class = DiamondSale::DiamondSaleInvoice
        when 'D'
          return
        end
        orig_lines = DiamondSale::DiamondSaleCreditLine.find_all_by_diamond_sale_id(id)
      when 'DiamondSale::DiamondSaleMemoReturn'
        refline_class = DiamondSale::DiamondSaleMemoLine
        ref_class = DiamondSale::DiamondSaleMemo
        orig_lines = DiamondSale::DiamondSaleMemoReturnLine.find_all_by_diamond_sale_id(id)
      else
      end
      curr_lines = self.diamond_sale_lines
      return ref_class, refline_class, curr_lines, orig_lines
  end

  private :identify_sales_post_classes_and_lines, :unpost_sales_transaction, :post_sales_transaction

end  
