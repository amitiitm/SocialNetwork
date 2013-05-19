xml.instruct! :xml, :version=>"1.0"
xml.tag!("#{@tag_level1}"){
  #  xml.multiple_invoices('Y')
  column_names = []
  @data_rows[0].each {|column_name| column_names << column_name.downcase} if @data_rows[0]
  @data_rows.each_with_index {|row,index|
    msg = ''
    account_period = ''
    vendor = ''
    trans_date = ''
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
        column=column.to_i.to_s if !(col_len < column.length) and !(column.length==0)
        case index
        when 0
          if !(column.length==0)
            column=column.to_i.to_s if !(col_len < column.length)
            invoice = Vendor::VendorInvoice.find_by_trans_no(column)
            if invoice
              msg=msg+"Invoice No already exist.please correct it \\n "
            end
          else
            msg=msg+"Invoice No cannot be blank \\n "
          end
        when 1
          trans_date = column
          column_names[index] = 'trans_date'
          account_period = Setup::AccountPeriod.period_from_date(trans_date)
          msg = msg+"Account Period closed or not exists"  unless account_period.code
        when 2
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
        when 3
          if (column and column!='')
            column=column.to_i.to_s if !(col_len < column.length) and !(column.length==0)
            inv_type = Setup::Type.find_by_type_cd_and_subtype_cd_and_value( 'faap','inv_type',column)
            if !inv_type
              msg = msg+"Invoice type does not exist.please enter valid invoice type \\n "
            else
              xml.invoice_type(column)
            end
          else
            xml.invoice_type('EXP')
          end
        when 4
          #          if  !(/^[0-9]{1,8}\.[0-9]{1,2}$/ =~column)
          #            msg = msg + "#{column_names[index]} require numeric data.please enter valid number in decimal(10,2)\\n "
          #          end
        when 5
          if column
            column=column.to_i.to_s if !(col_len < column.length) and !(column.length==0)
            term = Setup::Term.find_by_code(column)
            if !term
              msg = msg+"Term does not exist.please enter valid term \\n "
            end
          else
            msg=msg+"Term can't be Blank \\n"
          end
        when 9
          column_names[index] =  'description'
          if !(column.length <= 100)
            msg=msg+"item description can't be greater than 100 characters \\n"
          end
        end
        xml.tag!(column_names[index],column)
      }
      #      terms = Setup::Term.fill_terms(vendor.invoice_term_code,trans_date.to_datetime)
      #      xml.term_code(terms.code)
      #      xml.due_date(terms.pay1_date)
      xml.account_period_code(account_period.code)
      xml.message(msg)
      gl_account = GeneralLedger::GlAccount.find_by_id(vendor.gl_account_id) if vendor
      if gl_account
        xml.vendor_invoice_line_gl_account_id(gl_account.id)
        xml.vendor_invoice_line_gl_code(gl_account.code)
        xml.vendor_invoice_line_gl_name(gl_account.name)
      end
    end if index > 0
  }
}