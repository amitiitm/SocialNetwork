xml.instruct! :xml, :version=>"1.0" 

xml.gl_transactions{
  for gl_transaction in @journals
    xml.gl_transaction do
      gl_transaction.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)amt(.*)/  and column_value)
        xml.tag!(column_name, column_value)
      }
      xml.gl_transaction_lines{
        for gl_transaction_line in gl_transaction.gl_transaction_lines.applied_lines
          xml.gl_transaction_line do
            gl_transaction_line.attributes.each_pair{ |column_name,column_value|
              column_value = format_column(column_value)
              column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)amt(.*)/  and column_value)
              xml.tag!(column_name, column_value)
            }
            gl = gl_transaction_line.gl_account
            xml.gl_code(gl.code) if gl
            xml.gl_name(gl.name) if gl
          end
        end
      }
    end
  end
}
