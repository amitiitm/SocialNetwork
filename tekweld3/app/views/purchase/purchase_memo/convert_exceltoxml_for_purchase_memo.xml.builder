xml.instruct! :xml, :version=>"1.0"
xml.tag!("#{@tag_level1}"){
  column_names = []
  @data_rows[0].each {|column_name| column_names << column_name.downcase} if @data_rows[0]
  @data_rows.each_with_index {|row,index|
    msg = ''; account_period = ''; vendor = ''; trans_date = '';
    vendor_ref_no = '' ;  po_date = ''; customer_sku_no = '' ;item_qty='';
    ref_trans_bk = '' ; ref_trans_no = '' ; ref_serial_no = ''; ref_trans_date = ''; ref_type = '' ; transaction_bom_id = '';
    is_bom =  Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','jewelry_default','bom_in_transaction'])
    batch_flag =  Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','invn','generate_batch'])
    packet_flag =  Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','invn','packet_required'])
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
          vendor_ref_no = column if column
          vendor_ref_no = vendor_ref_no.to_i.to_s    if  !(vendor_ref_no=~/^[0-9].{0,9}$/) #to check is the column value is numeric
          purchase_memo = Purchase::PurchaseMemo.find_by_ext_ref_no(vendor_ref_no)
          msg = msg + "REF no alreasy exist. " if purchase_memo
          xml.vendor_ref_no(vendor_ref_no)
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
        when 12
          if !(column.length==0) and (column.length <= 18)
            column=column.to_i.to_s if !(col_len < column.length)
            column_names[index] =  'item_code'
            catalog_item=Item::CatalogItem.find_by_store_code(column)
            if !catalog_item
              msg=msg+"item does not exist.please enter valid item# \\n "
            else
              xml.catalog_item_id(catalog_item.id)
              xml.item_description(catalog_item.purchase_description)
            end
          else
            msg=msg+"item code can't be Blank or greater than 25 characters \\n"
          end
        when 15
          if (  batch_flag and batch_flag.value =='Y' )
            if !(column.length==0) and (column.length <= 25)
              column=column.to_i.to_s if !(col_len < column.length) 
              column_names[index] =  'batch_code'
              catalog_item_batch = ItemBatch::CatalogItemBatch.find_by_code(column)
              if !catalog_item_batch
                msg = msg+"Batch does not exist.please enter valid batch# \\n "
              else
                bom = TransactionBom::TransactionBom.find_by_catalog_item_batch_id(catalog_item_batch.id)
                xml.catalog_item_batch_id(catalog_item_batch.id)
                xml.transaction_bom_id(bom.id) if bom
                msg = msg+"BOM not found" if !bom
              end
            else 
              msg=msg+"batch code can't be Blank or greater than 25 characters \\n"
            end
          end
        when 16
          if (  packet_flag and packet_flag.value =='Y' )
            if !(column.length==0) and (column.length <= 25)
              column=column.to_i.to_s if !(col_len < column.length) 
              column_names[index] =  'packet_code'
              catalog_item_packet = Item::CatalogItemPacket.find_by_code(column)
              if !catalog_item_packet
                msg = msg+"Packet does not exist.please enter valid packet# \\n "
              else
                xml.catalog_item_packet_id(catalog_item_packet.id)
              end
            else 
              msg=msg+"packet code can't be Blank or greater than 25 characters \\n"
            end
          end
        end
        xml.tag!(column_names[index],column) if column_names[index]!='vendor_ref_no'
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
      xml.message(msg)
    end if index > 0
  }
}