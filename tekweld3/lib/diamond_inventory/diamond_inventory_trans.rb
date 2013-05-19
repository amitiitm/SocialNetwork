module DiamondInventory::DiamondInventoryTrans

  class Posting
    include General
    include ClassMethods
    def create_inventory_postings(object)
      curr_lines = object.diamond_inventory_lines
      inventory_postings = []
      curr_lines.each{|curr_line|
        account_period_code = curr_line.account_period_code
        diamond_lot_id = curr_line.diamond_lot_id
        diamond_packet_id = nulltozero(curr_line.diamond_packet_id)
        stone_type = nulltozero(curr_line.stone_type)
        location_code = nulltozero(curr_line.location_code)
        color = nulltozero(curr_line.color)
        clarity = nulltozero(curr_line.clarity)
        shape = nulltozero(curr_line.shape)
        quality = nulltozero(curr_line.quality)
        trans_bk = curr_line.trans_bk
        trans_no = curr_line.trans_no
        company_id = curr_line.company_id
        trans_date = curr_line.trans_date
        serial_no = curr_line.serial_no
        sell_unit = curr_line.sell_unit
        #added by Minal
        diamond_lot_no = curr_line.diamond_lot_no
        diamond_packet_no = nulltozero(curr_line.diamond_packet_no) if curr_line.diamond_packet_no
        trans_type = object.trans_type
        trans_type_id = object.trans_type_id
        remarks = object.remarks
        trans_flag = curr_line.trans_flag
        case curr_line.ri_flag
        when 'I'
          item_pcs = curr_line.iss_pcs
          item_price = curr_line.iss_price
          net_amt = curr_line.iss_amt
          net_wt= curr_line.iss_wt
        when 'R'
          item_pcs = curr_line.rec_pcs
          item_price = curr_line.rec_price
          net_amt = curr_line.rec_amt
          net_wt= curr_line.rec_wt
        end
        inventory_posting = fill_inventory_posting(curr_line.ri_flag, INVN_MEMO_NO, account_period_code,diamond_lot_id, diamond_packet_id, 
          item_pcs, item_price, net_amt,net_wt, trans_bk, trans_no,company_id,trans_date,serial_no,
          location_code,stone_type,shape,color,clarity,quality,diamond_lot_no,diamond_packet_no,trans_type,trans_type_id,remarks,trans_flag,sell_unit)
        inventory_postings << inventory_posting
      }
      inventory_postings
    end 

    def fill_inventory_posting(ri_flag, memo_flag, account_period_code, diamond_lot_id, diamond_packet_id, item_pcs, item_price, net_amt,net_wt, trans_bk, trans_no, company_id, trans_date,serial_no,location_code,stone_type,shape,color,clarity,quality,diamond_lot_no,diamond_packet_no,trans_type,trans_type_id,remarks,trans_flag,sell_unit)
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
      inventory_posting.stone_type =stone_type
      inventory_posting.shape = shape
      inventory_posting.color = color
      inventory_posting.clarity = clarity
      inventory_posting.quality = quality
      inventory_posting.diamond_lot_no = diamond_lot_no
      inventory_posting.diamond_packet_no = diamond_packet_no
      inventory_posting.ri_flag = ri_flag
      inventory_posting.remarks = remarks
      #added by Minal
      inventory_posting.trans_type = trans_type
      inventory_posting.trans_type_id = trans_type_id
      inventory_posting.trans_flag = trans_flag
      inventory_posting.sell_unit = sell_unit
      if memo_flag == INVN_MEMO_YES
      else
        case ri_flag
        when INVN_ISSUE
          inventory_posting.stock_iss_pcs = item_pcs 
          inventory_posting.stock_iss_price = item_price
          inventory_posting.stock_iss_amt = net_amt
          inventory_posting.stock_iss_wt = net_wt
        when INVN_RECEIVE
          inventory_posting.stock_rec_pcs = item_pcs
          inventory_posting.stock_rec_price = item_price
          inventory_posting.stock_rec_amt = net_amt
          inventory_posting.stock_rec_wt = net_wt
        end
      end
      inventory_posting
    end

    private :fill_inventory_posting
  end
end  
