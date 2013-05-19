module Inventory::InventorySales

  class Posting
    include General
    include ClassMethods
    def create_inventory_postings(object)
      memo_flag, ri_flag = identify_memo_ri_flags(object)
      curr_lines = identify_post_lines(object)
      inventory_postings = []
      curr_lines.each{|curr_line|
        if curr_line.item_type != 'S'
          account_period_code = curr_line.account_period_code
          trans_type = 'C'
          trans_type_id = object.customer_id
          ext_ref_no = object.ext_ref_no
          ext_ref_date = object.ext_ref_date
          catalog_item_id = curr_line.catalog_item_id
          catalog_item_packet_id = nulltozero(curr_line.catalog_item_packet_id)
          item_qty = curr_line.item_qty
          item_price = curr_line.item_price
          net_amt = curr_line.net_amt
          trans_bk = curr_line.trans_bk
          trans_no = curr_line.trans_no
          company_id = curr_line.company_id
          trans_date = curr_line.trans_date
          serial_no = curr_line.serial_no
          trans_flag = curr_line.trans_flag
          inventory_posting = fill_inventory_posting(ri_flag, memo_flag, account_period_code, catalog_item_id, catalog_item_packet_id,
            item_qty, item_price, net_amt, trans_bk, trans_no,company_id,trans_date,serial_no,trans_type,trans_type_id,ext_ref_no,ext_ref_date,trans_flag)
          inventory_postings << inventory_posting
        end
      }
      inventory_postings = identify_attributes_lines(object,inventory_postings,ri_flag, memo_flag) if (object.trans_type == 'O' and object.ref_type == 'O')
      inventory_postings
    end 

    def identify_attributes_lines(object,inventory_postings,ri_flag, memo_flag)
      order = Sales::SalesOrder.find_by_trans_no(object.ref_trans_no)
      #      curr_lines.each{|curr_line|
      #        if curr_line.item_type == 'I'
      #          curr_line = curr_line
      #        end
      #      }
      curr_lines = Sales::SalesInvoiceLine.find_all_by_sales_invoice_id_and_item_type(object.id,'I')
      curr_lines.each{|curr_line|
        attributes_values = Sales::SalesOrderAttributesValue.find_all_by_sales_order_id_and_catalog_item_id_and_trans_flag(order.id,curr_line.catalog_item_id,'A')
        attributes_values.each { |value|
          ## this if condition is newly added on 10Aug2012 By AmitPandey to post multi description object.
          if value.catalog_attribute_value_code == 'MULTI'
            if !curr_line.multi_description.blank?
              inventory_postings = build_multi_attribute_posting_object(inventory_postings,object,curr_line,value,ri_flag, memo_flag)
            end
          else
            attribute_code = Item::CatalogAttribute.find_by_code(value.catalog_attribute_code)
            catalog_attribute_value = Item::CatalogAttributeValue.find_by_catalog_attribute_id_and_code(attribute_code.id,value.catalog_attribute_value_code)
            if (catalog_attribute_value and catalog_attribute_value.invn_item_id and catalog_attribute_value.invn_item_id != '')
              account_period_code = curr_line.account_period_code
              trans_type = 'C'
              trans_type_id = object.customer_id
              ext_ref_no = object.ext_ref_no
              ext_ref_date = object.ext_ref_date

              catalog_item_id = catalog_attribute_value.invn_item_id

              catalog_item_packet_id = nulltozero(curr_line.catalog_item_packet_id)
              item_qty = curr_line.item_qty
              item_price = curr_line.item_price
              net_amt = curr_line.net_amt
              trans_bk = curr_line.trans_bk
              trans_no = curr_line.trans_no
              company_id = curr_line.company_id
              trans_date = curr_line.trans_date
              serial_no = curr_line.serial_no
              trans_flag = curr_line.trans_flag
              inventory_posting = fill_inventory_posting(ri_flag, memo_flag, account_period_code, catalog_item_id, catalog_item_packet_id,
                item_qty, item_price, net_amt, trans_bk, trans_no,company_id,trans_date,serial_no,trans_type,trans_type_id,ext_ref_no,ext_ref_date,trans_flag)
              inventory_postings << inventory_posting
            end
          end
        }
      }
      inventory_postings
    end

    def build_multi_attribute_posting_object(inventory_postings,object,curr_line,attrvalue_obj,ri_flag, memo_flag)
      qty = []
      attribute_values = []
      curr_line.multi_description.split(/;/).each do |i|
        qty << i.split(/=/).last
        attribute_values << i.split(/=/).first
      end
      qty_count = 0
      attribute_values.each{|value|
        attribute_code = Item::CatalogAttribute.find_by_code(attrvalue_obj.catalog_attribute_code)
        catalog_attribute_value = Item::CatalogAttributeValue.find_by_catalog_attribute_id_and_code(attribute_code.id,value)
        if (catalog_attribute_value and catalog_attribute_value.invn_item_id and catalog_attribute_value.invn_item_id != '')
          account_period_code = curr_line.account_period_code
          trans_type = 'C'
          trans_type_id = object.customer_id
          ext_ref_no = object.ext_ref_no
          ext_ref_date = object.ext_ref_date

          catalog_item_id = catalog_attribute_value.invn_item_id

          catalog_item_packet_id = nulltozero(curr_line.catalog_item_packet_id)
          item_qty = qty[qty_count].to_i
          item_price = curr_line.item_price
          net_amt = curr_line.net_amt
          trans_bk = curr_line.trans_bk
          trans_no = curr_line.trans_no
          company_id = curr_line.company_id
          trans_date = curr_line.trans_date
          serial_no = curr_line.serial_no
          trans_flag = curr_line.trans_flag
          inventory_posting = fill_inventory_posting(ri_flag, memo_flag, account_period_code, catalog_item_id, catalog_item_packet_id,
            item_qty, item_price, net_amt, trans_bk, trans_no,company_id,trans_date,serial_no,trans_type,trans_type_id,ext_ref_no,ext_ref_date,trans_flag)
          inventory_postings << inventory_posting
        end
        qty_count = qty_count + 1
      }
      inventory_postings
    end

    def fill_inventory_posting(ri_flag, memo_flag, account_period_code, catalog_item_id, catalog_item_packet_id, item_qty, item_price, net_amt, trans_bk, trans_no,company_id,trans_date,serial_no,trans_type,trans_type_id,ext_ref_no,ext_ref_date,trans_flag)
      inventory_posting = Inventory::InventoryPosting.new
      inventory_posting.trans_bk = trans_bk
      inventory_posting.trans_no = trans_no
      inventory_posting.company_id = company_id
      inventory_posting.trans_date = trans_date
      inventory_posting.serial_no = serial_no
      inventory_posting.update_flag = 'V'
      inventory_posting.account_period_code = account_period_code
      inventory_posting.trans_type = trans_type
      inventory_posting.trans_type_id = trans_type_id
      inventory_posting.ext_ref_no = ext_ref_no
      inventory_posting.ext_ref_date = ext_ref_date
      inventory_posting.catalog_item_id = catalog_item_id
      inventory_posting.catalog_item_packet_id = catalog_item_packet_id
      inventory_posting.receipt_issue_flag = ri_flag
 
      inventory_posting.trans_flag = trans_flag
      if memo_flag == INVN_MEMO_YES
        case ri_flag
        when INVN_ISSUE
          inventory_posting.memo_iss_qty = item_qty 
          inventory_posting.memo_iss_price = item_price
          inventory_posting.memo_iss_amt = net_amt
        when INVN_RECEIVE
          inventory_posting.memo_rec_qty = item_qty 
          inventory_posting.memo_rec_price = item_price
          inventory_posting.memo_rec_amt = net_amt
        end
      else
        case ri_flag
        when  INVN_TRANSFER
          inventory_posting.memo_rec_qty = item_qty  
          inventory_posting.memo_rec_price = item_price
          inventory_posting.memo_rec_amt = net_amt
          inventory_posting.stock_iss_qty = item_qty  
          inventory_posting.stock_iss_price = item_price
          inventory_posting.stock_iss_amt = net_amt
        when INVN_ISSUE
          inventory_posting.stock_iss_qty = item_qty 
          inventory_posting.stock_iss_price = item_price
          inventory_posting.stock_iss_amt = net_amt
        when INVN_RECEIVE
          inventory_posting.stock_rec_qty = item_qty
          inventory_posting.stock_rec_price = item_price
          inventory_posting.stock_rec_amt = net_amt
        end
      end
      inventory_posting
    end

    def identify_memo_ri_flags(object)
      memo_flag = INVN_MEMO_NO ;  ri_flag=INVN_RECEIVE
      case object.class.name
      when 'Sales::SalesOrder'
        memo_flag = INVN_MEMO_NO
        ri_flag = INVN_ISSUE
      when 'Sales::SalesInvoice'
        memo_flag = INVN_MEMO_NO
        memo?(object.trans_type)? ri_flag = INVN_TRANSFER : ri_flag = INVN_ISSUE
      when 'Sales::SalesMemo'
        memo_flag = INVN_MEMO_YES ; ri_flag = INVN_ISSUE
      when 'Sales::SalesCreditInvoice'
        memo_flag = INVN_MEMO_NO ;  ri_flag = INVN_RECEIVE
      when 'Sales::SalesMemoReturn'
        memo_flag = INVN_MEMO_YES ; ri_flag = INVN_RECEIVE
        #Newly added for POS
      when 'PointOfSale::PosInvoice'
        memo_flag = INVN_MEMO_NO
        ri_flag = INVN_ISSUE
      else
      end
      return memo_flag, ri_flag
    end

    def identify_post_lines(object)
      case object.class.name
      when 'Sales::SalesOrder'
        object_lines = object.sales_order_lines
      when 'Sales::SalesInvoice'
        object_lines = object.sales_invoice_lines
      when 'Sales::SalesMemo'
        object_lines = object.sales_memo_lines
      when 'Sales::SalesCreditInvoice'
        object_lines = object.sales_credit_invoice_lines
      when 'Sales::SalesMemoReturn'
        object_lines = object.sales_memo_return_lines
        #Newly added for POS
      when 'PointOfSale::PosInvoice'
        object_lines = object.pos_invoice_lines
      else
      end
      return object_lines
    end

    private :fill_inventory_posting, :identify_memo_ri_flags, :identify_post_lines
  end
end  
