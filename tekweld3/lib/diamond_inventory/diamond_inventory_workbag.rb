module DiamondInventory::DiamondInventoryWorkbag

  class Posting
    include General
    include ClassMethods
    def create_inventory_postings(object)
      curr_lines = identify_post_lines(object)
      inventory_postings = []
      curr_lines.each{|curr_line|
        account_period_code = curr_line.account_period_code
        diamond_lot_id = curr_line.stone_lot_id
        diamond_packet_id = nulltozero(curr_line.stone_packet_id)
        pcs = curr_line.qty
        wt = curr_line.wt
        price = curr_line.price
        net_amt = curr_line.total_amt
        trans_bk = curr_line.trans_bk
        trans_no = curr_line.trans_no
        company_id = curr_line.company_id
        trans_date = curr_line.trans_date
        serial_no = curr_line.serial_no
        customer_vendor_flag = 'C'
        customer_vendor_id = object.customer_id
        location_code ='NA'
        stone_type = curr_line.stone_type
        shape = curr_line.stone_shape
        color = curr_line.stone_color
        clarity = curr_line.stone_clarity
        quality = curr_line.stone_quality
        cost = curr_line.cost
        sell_unit = 'PCS'
        trans_flag= curr_line.trans_flag
        ext_ref_date = object.vendor_po_date
        ext_ref_no = object.vendor_po_no
        inventory_posting = fill_inventory_posting(account_period_code, diamond_lot_id, diamond_packet_id, 
          pcs, wt, price, net_amt, trans_bk, trans_no, company_id, trans_date,serial_no,
          stone_type,shape,color,clarity,quality,cost,customer_vendor_id,customer_vendor_flag,trans_flag,location_code,sell_unit,ext_ref_no,ext_ref_date)
        inventory_postings << inventory_posting
      }
      inventory_postings
    end 

    def fill_inventory_posting(account_period_code, diamond_lot_id, diamond_packet_id, pcs, wt, price, net_amt, trans_bk, trans_no, company_id, trans_date,serial_no,stone_type,shape,color,clarity,quality,cost,customer_vendor_id,customer_vendor_flag,trans_flag,location_code,sell_unit,ext_ref_no,ext_ref_date)
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
      inventory_posting.ext_ref_no = ext_ref_no
      inventory_posting.ext_ref_date = ext_ref_date
      inventory_posting.ri_flag = 'I'
      inventory_posting.trans_type_id=customer_vendor_id
      inventory_posting.trans_type=customer_vendor_flag
      inventory_posting.trans_flag=trans_flag
      inventory_posting.stock_iss_pcs = pcs 
      inventory_posting.stock_iss_wt = wt 
      inventory_posting.stock_iss_price = price
      inventory_posting.stock_iss_amt = net_amt
      inventory_posting
    end

    def identify_post_lines(object)
      case object.class.name
      when 'Production::Workbag'
        object_lines = object.workbag_stone_issues
      else
      end
      return object_lines
    end

    private :fill_inventory_posting,:identify_post_lines
  end
end  
