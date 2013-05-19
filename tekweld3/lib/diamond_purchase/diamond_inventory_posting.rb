module DiamondPurchase::DiamondInventoryPosting
  include General
  include ClassMethods
  
  def check_flags()
    memo_flag = 'N'
    ri_flag='R'
    case 
    when self.trans_type == 'I' # invoice is Receipt
      memo_flag = 'N'
      ri_flag = 'T' # for invoice it is transfer, memo return/invoice receipt.
    when self.trans_type == 'M' # memo is Receipt
      memo_flag = 'Y'
      ri_flag = 'R'
    when self.trans_type == 'C' # credit is issue
      memo_flag = 'N'
      ri_flag = 'I'
    when self.trans_type == 'R' # Return is issue
      memo_flag = 'Y'
      ri_flag = 'I'
    end 
    return memo_flag, ri_flag
  end
  
  def create_inventory_postings()
      memo_flag, ri_flag = check_flags()
      invndetails = []
      diamond_purchase_lines.applied_lines.each{|lineitem|
          iss_pcs = 0
          iss_wt = 0
          rec_pcs = 0
          rec_wt = 0
          if self.trans_type == 'M' or  self.trans_type == 'I'
            rec_pcs = lineitem.pcs
            rec_wt = lineitem.wt
          else
          if self.trans_type == 'C' or self.trans_type == 'R'
            iss_pcs = lineitem.pcs
            iss_wt = lineitem.wt
          end
          end
          line_amt = lineitem.line_amt
          price = lineitem.price
          sell_unit = lineitem.sell_unit
          diamond_lot_id = lineitem.diamond_lot_id
          company_id=lineitem.company_id
          stone_type=lineitem.stone_type
          shape=lineitem.shape
          color=lineitem.color
          quality=lineitem.quality
          clarity=lineitem.clarity
          diamond_packet_id = lineitem.diamond_packet_id
          location_code = lineitem.location_code
          location_code = 'NA' if location_code.nil? or location_code.blank?
          
          invndetail = fill_inventory_detail(ri_flag, memo_flag, diamond_lot_id, diamond_packet_id, iss_pcs, iss_wt, rec_pcs, rec_wt, location_code, line_amt, price, sell_unit,company_id,stone_type,shape,color,clarity,quality)
          invndetails << invndetail
      }
      invndetails
  end 

  def fill_inventory_detail(ri_flag, memo_flag, diamond_lot_id, diamond_packet_id, iss_pcs, iss_wt, rec_pcs, rec_wt, location_code, line_amt, price, sell_unit,company_id,stone_type,shape,color,clarity,quality)
    invndetail = DiamondInventory::DiamondInventoryDetail.new
    invndetail.trans_bk = self.trans_bk
    invndetail.trans_no = self.trans_no
    invndetail.company_id = self.company_id
    invndetail.trans_date = self.trans_date
    invndetail.customer_vendor_id = self.vendor_id
    invndetail.customer_vendor_flag = 'V'
    invndetail.trans_type = 'VEND'
    invndetail.account_period_code = self.account_period_code
    invndetail.remarks = ' '
    invndetail.update_flag = 'V'
    invndetail.trans_flag = self.trans_flag
    invndetail.diamond_lot_id = diamond_lot_id
    invndetail.diamond_packet_id = diamond_packet_id
    invndetail.location_code = location_code
    invndetail.company_id=company_id
    invndetail.stone_type=stone_type
    invndetail.shape=shape
    invndetail.color=color
    invndetail.quality=quality
    invndetail.clarity=clarity
    if memo_flag =='Y'
      case 
      when ri_flag == 'I'
        invndetail.memo_iss_pcs = iss_pcs
        invndetail.memo_iss_wt = iss_wt
        invndetail.memo_iss_amt = line_amt
        invndetail.memo_iss_price = price
      when  ri_flag == 'R'
        invndetail.memo_rec_pcs = rec_pcs
        invndetail.memo_rec_wt = rec_wt
        invndetail.memo_rec_amt = line_amt
        invndetail.memo_rec_price = price
      end
    else
      case 
      when ri_flag == 'T'
        invndetail.memo_iss_pcs = iss_pcs 
        invndetail.memo_iss_wt = iss_wt
        invndetail.memo_iss_amt = line_amt
        invndetail.memo_iss_price = price
        invndetail.stock_rec_pcs = iss_pcs 
        invndetail.stock_rec_wt = iss_wt
        invndetail.stock_rec_amt = line_amt
        invndetail.stock_rec_price = price
      when ri_flag == 'I'
        invndetail.stock_iss_pcs = iss_pcs
        invndetail.stock_iss_wt = iss_wt
        invndetail.stock_iss_amt = line_amt
        invndetail.stock_iss_price = price
      when ri_flag == 'R'
        invndetail.stock_rec_pcs = rec_pcs
        invndetail.stock_rec_wt = rec_wt
        invndetail.stock_rec_amt = line_amt
        invndetail.stock_rec_price = price
      end
    end
    invndetail.sell_unit = sell_unit
    invndetail
  end
end  
