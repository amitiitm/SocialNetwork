xml.instruct! :xml, :version=>"1.0" 
xml.bank_transactions{
if !@bank_transaction.empty?
  xml.bank_transaction do
    bank_transaction =  @bank_transaction.first  
    if bank_transaction
      bank_transaction.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.bank_name(bank_transaction.bank1_name)
      xml.bank2_name(bank_transaction.bank2_name)
      xml.bank_transaction_lines do
        bank_transaction.bank_transaction_lines.each{|line| 
          if line.trans_flag =='A'
            xml.bank_transaction_line do
              line.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
              gl = line.gl_account
              xml.gl_code(gl.code) if gl
              xml.gl_name(gl.name) if gl
            end
        end
      }
      end
    end
  xml.gl_transaction_lines do
    if !@bank_transaction.empty? 
      if @bank_transaction[1]
        gl_transactions = @bank_transaction[1] 
          gl_transactions.each{|gl_line|
            xml.gl_transaction_line do
              gl_line.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value) 
                }
              xml.serial_no(gl_line.dtl_serial_no) 
              gl = gl_line.gl_account   
              xml.gl_code(gl.code) if gl
              xml.gl_name(gl.name) if gl
            end
          }
      end  
    end
  end
#  if !bank_transaction.errors.empty?
#    bank_transaction.errors.each {|error,msg| 
#      xml.error(error,msg) 
#    }
#  end 
  end
end
}   

