module DiamondInventory::DiamondInventorySales

  class Posting
    include General
    include ClassMethods
    def create_inventory_postings(object)
      memo_flag, ri_flag = identify_memo_ri_flags(object)
      curr_lines = identify_post_lines(object)
      inventory_postings = []
      curr_lines.each{|curr_line|
        account_period_code = curr_line.account_period_code
        diamond_lot_id = curr_line.diamond_lot_id
        diamond_packet_id = nulltozero(curr_line.diamond_packet_id)
        pcs = curr_line.pcs
        wt = curr_line.wt
        price = curr_line.price
        net_amt = curr_line.net_amt
        trans_bk = curr_line.trans_bk
        trans_no = curr_line.trans_no
        company_id = curr_line.company_id
        trans_date = curr_line.trans_date
        serial_no = curr_line.serial_no
        #Added by Minal
        customer_vendor_flag = 'C'
        customer_vendor_id = object.customer_id
        location_code = curr_line.location_code
        stone_type = curr_line.stone_type
        shape = curr_line.shape
        color = curr_line.color
        clarity = curr_line.clarity
        quality = curr_line.quality
        cost = curr_line.cost
        sell_unit = curr_line.sell_unit
        trans_flag= curr_line.trans_flag
        ext_ref_date = object.po_date
        ext_ref_no = object.po_no
        inventory_posting = fill_inventory_posting(ri_flag, memo_flag, account_period_code, diamond_lot_id, diamond_packet_id, 
                                                  pcs, wt, price, net_amt, trans_bk, trans_no, company_id, trans_date,serial_no,
                                                 location_code,stone_type,shape,color,clarity,quality,cost,sell_unit,customer_vendor_id,customer_vendor_flag,ext_ref_no,ext_ref_date,trans_flag)
        inventory_postings << inventory_posting
      }
      inventory_postings
    end 

    def fill_inventory_posting(ri_flag, memo_flag, account_period_code, diamond_lot_id, diamond_packet_id, pcs, wt, price, net_amt, trans_bk, trans_no, company_id, trans_date,serial_no,location_code,stone_type,shape,color,clarity,quality,cost,sell_unit,customer_vendor_id,customer_vendor_flag,ext_ref_no,ext_ref_date,trans_flag)
      inventory_posting = DiamondInventory::DiamondInventoryPosting.new
      inventory_posting.trans_bk = trans_bk
      inventory_posting.trans_no = trans_no
      inventory_posting.company_id = company_id
      inventory_posting.trans_date = trans_date
      inventory_posting.serial_no = serial_no
      inventory_posting.update_flag = 'V'
      inventory_posting.account_period_code = account_period_code
      inventory_posting.diamond_lot_id = diamond_lot_id
      inventory_posting.diamond_packet_id = diamond_packet_id
      inventory_posting.location_code = location_code
      inventory_posting.stone_type = stone_type
      inventory_posting.shape = shape
      inventory_posting.color = color
      inventory_posting.clarity = clarity
      inventory_posting.quality = quality
      inventory_posting.cost = cost
      inventory_posting.sell_unit = sell_unit
      inventory_posting.ri_flag = ri_flag
      inventory_posting.ext_ref_no = ext_ref_no
      inventory_posting.ext_ref_date = ext_ref_date
      #Added by Minal
#      inventory_posting.customer_vendor_id=customer_vendor_id
#      inventory_posting.customer_vendor_flag=customer_vendor_flag
      inventory_posting.trans_type_id=customer_vendor_id
      inventory_posting.trans_type=customer_vendor_flag
      inventory_posting.trans_flag=trans_flag
      if memo_flag == INVN_MEMO_YES
        case ri_flag
        when INVN_ISSUE
          inventory_posting.memo_iss_pcs = pcs 
          inventory_posting.memo_iss_wt = wt
          inventory_posting.memo_iss_price = price
          inventory_posting.memo_iss_amt = net_amt
        when INVN_RECEIVE
          inventory_posting.memo_rec_pcs = pcs 
          inventory_posting.memo_rec_wt = wt
          inventory_posting.memo_rec_price = price
          inventory_posting.memo_rec_amt = net_amt
        end
      else
        case ri_flag
        when  INVN_TRANSFER
          inventory_posting.memo_rec_pcs = pcs  
          inventory_posting.memo_rec_wt = wt  
          inventory_posting.memo_rec_price = price
          inventory_posting.memo_rec_amt = net_amt
          inventory_posting.stock_iss_pcs = pcs  
          inventory_posting.stock_iss_wt = wt  
          inventory_posting.stock_iss_price = price
          inventory_posting.stock_iss_amt = net_amt
        when INVN_ISSUE
          inventory_posting.stock_iss_pcs = pcs 
          inventory_posting.stock_iss_wt = wt 
          inventory_posting.stock_iss_price = price
          inventory_posting.stock_iss_amt = net_amt
        when INVN_RECEIVE
          inventory_posting.stock_rec_pcs = pcs
          inventory_posting.stock_rec_wt = wt
          inventory_posting.stock_rec_price = price
          inventory_posting.stock_rec_amt = net_amt
        end
      end
      inventory_posting
    end

    def identify_memo_ri_flags(object)
      memo_flag = INVN_MEMO_NO ;  ri_flag=INVN_RECEIVE
      case object.class.name
      when 'DiamondSale::DiamondSaleInvoice'
        memo_flag = INVN_MEMO_NO
        memo?(object.ref_type)? ri_flag = INVN_TRANSFER : ri_flag = INVN_ISSUE
      when 'DiamondSale::DiamondSaleMemo'
        memo_flag = INVN_MEMO_YES ; ri_flag = INVN_ISSUE
      when 'DiamondSale::DiamondSaleCredit'
        memo_flag = INVN_MEMO_NO ;  ri_flag = INVN_RECEIVE
      when 'DiamondSale::DiamondSaleMemoReturn'
        memo_flag = INVN_MEMO_YES ; ri_flag = INVN_RECEIVE
      else
      end
      return memo_flag, ri_flag
    end

    def identify_post_lines(object)
#      case object.class.name
#      when 'DiamondSale::DiamondSaleInvoice'
#        object_lines = object.diamond_sale_invoice_lines
#      when 'DiamondSale::DiamondSaleMemo'
#        object_lines = object.diamond_sale_memo_lines
#      when 'DiamondSale::DiamondSaleCredit'
#        object_lines = object.diamond_sale_credit_lines
#      when 'DiamondSale::DiamondSaleMemoReturn'
#        object_lines = object.diamond_sale_memo_return_lines
#      else
#      end
       object_lines = object.diamond_sale_lines

      return object_lines
    end

    private :fill_inventory_posting, :identify_memo_ri_flags, :identify_post_lines
  end
end  
