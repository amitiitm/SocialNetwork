xml.instruct! :xml, :version=>"1.0" 
xml.bank_check_bounces{
  if !@bank_check_bounce.empty?
    xml.bank_check_bounce do
      bank_check_bounce =  @bank_check_bounce.first  
      if bank_check_bounce
        bank_check_bounce.attributes.each_pair{ |column_name,column_value|
          column_value = format_column(column_value)
          xml.tag!(column_name, column_value)
        }
        xml.bank_charges_account_id(bank_check_bounce.bank_charge_account_id)
        xml.bank_charges_account_code(bank_check_bounce.bank_charge_account_code)
      end
      xml.gl_transaction_lines do
        if @bank_check_bounce and @bank_check_bounce.length > 1
          gl_transactions = @bank_check_bounce[1]
          gl_transactions.each{|gl_line|
            xml.gl_transaction_line do
              gl_line.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)amt(.*)/  and column_value)
                xml.tag!(column_name, column_value) 
              }
              xml.serial_no(gl_line.dtl_serial_no)
              xml.gl_code(gl_line.gl_account.code) if gl_line.gl_account
              xml.gl_name(gl_line.gl_account.name) if gl_line.gl_account
            end
          }
        end  
      end
      xml.bank_charges_gl_transaction_lines do
        if @bank_check_bounce and @bank_check_bounce.length > 1
          gl_transactions = @bank_check_bounce[2]
          gl_transactions.each{|gl_line|
            xml.bank_charges_gl_transaction_line do
              gl_line.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)amt(.*)/  and column_value)
                xml.tag!(column_name, column_value) 
              }
              xml.serial_no(gl_line.dtl_serial_no)
              xml.gl_code(gl_line.gl_account.code) if gl_line.gl_account
              xml.gl_name(gl_line.gl_account.name) if gl_line.gl_account
            end
          }
        end  
      end
    end
  end
}   

