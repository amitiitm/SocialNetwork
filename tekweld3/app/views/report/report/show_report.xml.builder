xml.instruct! :xml, :version=>"1.0" 

xml.reports{
  for report in @reports
    xml.report do
      report.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.report_columns{
        for report_column in report.report_columns.find(:all,:order=> 'column_label') 
          if report_column.trans_flag=='A'
            xml.report_column do 
              report_column.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
            end
          end
        end
      }
      xml.report_layouts{
        for report_layout in report.report_layouts
          if( (report_layout.trans_flag == 'A') and (report_layout.layout_type == 'S'))
            xml.report_layout do
              report_layout.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
      
              xml.report_layout_columns{
                for report_layout_column in report_layout.report_layout_columns.find(:all,:order => 'column_sequence')
                  xml.report_layout_column do
                    report_layout_column.attributes.each_pair{ |column_name,column_value|
                      column_value = format_column(column_value)
                      xml.tag!(column_name, column_value)
                    }
                  end
                end
                #            }
                #            xml.report_layout_groups{
                #              for report_layout_group in report_layout.report_layout_groups
                #         
                #                xml.report_layout_group do
                #                  report_layout_group.attributes.each_pair{ |column_name,column_value|
                #                    column_value = format_column(column_value)
                #                    xml.tag!(column_name, column_value)
                #                  }
                #                end
                #              end
                #            }
                #            xml.report_layout_users{
                #              for report_layout_user in report_layout.report_layout_users
                #          
                #                xml.report_layout_user do
                #                  report_layout_user.attributes.each_pair{ |column_name,column_value|
                #                    column_value = format_column(column_value)
                #                    xml.tag!(column_name, column_value)
                #                  }
                #                end
                #              end
                ##            }
                ####newly added
              }
            end
          end
        end
      }
    end
  end
}
