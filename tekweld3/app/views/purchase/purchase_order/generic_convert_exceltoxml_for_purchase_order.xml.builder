xml.instruct! :xml, :version=>"1.0"
xml.tag!("#{@tag_level1}"){
  column_names = []
  @data_rows[0].each {|column_name| column_names << column_name.downcase} if @data_rows[0]
  @data_rows.each_with_index {|row,index|
    msg = ''; account_period = ''; vendor = ''; trans_date = '';
    po_no = '' ; item_code = '' ; po_date = ''; customer_sku_no = '' ;item_qty='';
    ref_trans_bk = '' ; ref_trans_no = '' ; ref_serial_no = ''; ref_trans_date = ''; ref_type = '' ; transaction_bom_id = '';
    is_bom =  Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','jewelry_default','bom_in_transaction'])
    xml.tag!("#{@tag_level2}") do
      row.each_with_index{|column,index|
        col_len=0
        column='' if !column
        column.each_byte do |ascii|
          if  (ascii > 47 and ascii < 58) or (ascii == 46) #to check ascii value between 0-9 and .
            col_len+=1
          else
            break
          end
        end
        case index
        when 0
          po_no = column if column
          po_no = po_no.to_i.to_s    if  (po_no=~/^[0-9].{0,9}$/) #to check is the column value is numeric
          purchase_order = Purchase::PurchaseOrder.find_by_ext_ref_no(po_no)
          msg = msg + "PO no alreasy exist. " if purchase_order
          xml.po_no(po_no)
        when 1
          po_date = column
        when 2
          trans_date = column
          column_names[index] = 'trans_date'
          account_period = Setup::AccountPeriod.period_from_date(trans_date)
        when 4
          if column
            column=column.to_i.to_s if !(col_len < column.length) and !(column.length==0)
            vendor = Vendor::Vendor.find_by_code(column)
            if !vendor
              msg = msg+"Vendor# does not exist.please enter valid vendor# \\n "
            else
              vendor.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                if column_name == 'id'
                  xml.vendor_id(column_value)
                else
                  xml.tag!(column_name, column_value)
                end
              }
            end
          else
            msg=msg+"Vendor# can't be Blank \\n"
          end
        when 5
          if (column and column!='')
            column=column.to_i.to_s if !(col_len < column.length) and !(column.length==0)
            term = Setup::Term.find_by_code(column)
            if !term
              msg = msg+"Term# does not exist.please enter valid term# \\n "
            end
          else
            msg=msg+"term# can't be Blank \\n"
          end
        when 7
          if (column and column!='')
            column=column.to_i.to_s if !(col_len < column.length) and !(column.length==0)
            shipping = Setup::Shipping.find_by_code(column)
            if !shipping
              msg = msg+"Ship# does not exist.please enter valid ship# \\n "
            end
          else
            msg=msg+"ship# can't be Blank \\n"
          end
        when 11
          if !(column.length==0) and (column.length <= 18)
            column=column.to_i.to_s if !(col_len < column.length)
            column_names[index] =  'item_code'
            catalog_item=Item::CatalogItem.find_by_store_code(column)
            item_code = column
            if !catalog_item
              msg=msg+"item does not exist.please enter valid item# \\n "
            else
              xml.catalog_item_id(catalog_item.id)
              xml.item_description(catalog_item.purchase_description)
            end
          else
            msg=msg+"item code can't be Blank or greater than 25 characters \\n"
          end
        when 13
          customer_sku_no = column if column
        when 14
          item_qty = column.to_i if column
        end
        xml.tag!(column_names[index],column) if column_names[index]!='po_no'
      }
      xml.account_period_code(account_period.code)
      if vendor
        xml.bill_name(vendor.name)
        xml.bill_code(vendor.code)
        xml.bill_address1(vendor.address1)
        xml.bill_address2(vendor.address2)
        xml.bill_city(vendor.city)
        xml.bill_state(vendor.state)
        xml.bill_zip(vendor.zip)
        xml.bill_country(vendor.country)
        xml.bill_phone(vendor.phone)
        xml.bill_fax(vendor.fax)
      end

      #to check is there sales order exists for given po
      sales_order = Sales::SalesOrder.find_by_ext_ref_no_and_ext_ref_date(po_no,po_date)
      if sales_order
        trans_type = 'O'
        ref_line =  sales_order.sales_order_lines.to_ary.find { |row| row.catalog_item_code == item_code and  row.customer_sku_no == customer_sku_no }
        if ref_line
          ref_trans_bk = sales_order.trans_bk
          ref_trans_no = sales_order.trans_no
          ref_serial_no = ref_line.serial_no
          ref_trans_date = sales_order.trans_date
          ref_type = sales_order.trans_type
          transaction_bom_id = ref_line.transaction_bom_id
          if (ref_line.item_qty-ref_line.clear_qty) - item_qty < 0
            msg = msg+" PO qty not available"
          end
        end
        msg = msg+"Reference line not found" if !ref_line
      else
        trans_type = 'D'
        if ( is_bom and is_bom.value == 'Y')
          bom = TransactionBom::TransactionBom.find_by_tag_line1_and_store_code_and_customer_sku_no(po_no,item_code,customer_sku_no)
          transaction_bom_id = bom.id if bom
          msg = msg+"Respective BOM not found " if !bom
        end
      end
      xml.trans_type(trans_type)
      xml.ref_trans_bk(ref_trans_bk)
      xml.ref_trans_no(ref_trans_no)
      xml.ref_serial_no(ref_serial_no)
      xml.ref_trans_date(ref_trans_date)
      xml.ref_type(ref_type)
      xml.transaction_bom_id(transaction_bom_id)
      xml.message(msg)
    end if index > 0
  }
}