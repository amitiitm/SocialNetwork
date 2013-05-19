xml.instruct! :xml, :version=>"1.0" 
fields = ['id','company_id','created_by','image_thumnail','taxable','updated_by','item_type','created_at','packet_require_yn','updated_at','update_flag','trans_flag','lock_version','trans_bk',
  'trans_no','trans_date','catalog_item_id','discount_per','discount_amt','serial_no','catalog_item_batch_code','updated_by_code','catalog_item_batch_id','customer_sku_no']
bom_yn = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','jewelry_default','bom_in_transaction'])
xml.purchase_packing_slips{
  for purchase_packing_slip in @ps
    xml.purchase_packing_slip do
      purchase_packing_slip.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.vendor_name(purchase_packing_slip.vendor.name)
      xml.purchase_packing_slip_lines{
        for purchase_packing_slip_line in purchase_packing_slip.purchase_packing_slip_lines
          if purchase_packing_slip_line.trans_flag == 'A'
            xml.purchase_packing_slip_line do
              purchase_packing_slip_line.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
              #new
              for bom in TransactionBom::TransactionBom.find_by_sql ["select * from transaction_boms where trans_flag='A' and  id=?",purchase_packing_slip_line.transaction_bom_id]
                bom.attributes.each_pair{ |column_name,column_value|
                  column_value = format_column(column_value)
                  xml.tag!(column_name, column_value) unless  fields.include?(column_name)
                }
              end
              if purchase_packing_slip_line.catalog_item
                xml.taxable(purchase_packing_slip_line.catalog_item.taxable)
                xml.packet_require_yn(purchase_packing_slip_line.catalog_item.packet_require_yn)
                xml.image_thumnail(purchase_packing_slip_line.catalog_item.image_thumnail) if  ( !bom_yn || bom_yn.value=='N')
                xml.image_thumnail(bom.image_thumnail)  if  ( bom and bom_yn and bom_yn.value=='Y')
                filename = purchase_packing_slip_line.catalog_item.image_thumnail
                if filename.nil? then filename = '' end
                if filename.strip == '' then filename = 'blank.jpg' end
                if File.exist?("#{Dir.getwd}/public/images/catalog/#{filename}") == true
                  filename = "http://#{request.env['HTTP_HOST']}/images/catalog/#{filename}"
                else
                  filename = "http://#{request.env['HTTP_HOST']}/images/catalog/blank.jpg"
                end
                xml.item_photo_url(filename)
              end 
              if bom
                xml.catalog_item_diamonds{
                  for catalog_item_diamond in bom.transaction_bom_diamonds.active
                    if catalog_item_diamond.trans_flag =='A'
                      xml.catalog_item_diamond do
                        catalog_item_diamond.attributes.each_pair{ |column_name,column_value|
                          column_value = format_column(column_value)
                          column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)cost(.*)/ and column_value)
                          column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)amt(.*)/ and column_value)
                          column_value = sprintf( "%0.03f", column_value) if (column_name =~ /(.*)wt(.*)/ and column_value and column_name != 'billed_wt_flag')
                          column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)rate(.*)/ and column_value)
                          xml.tag!(column_name, column_value)
                          xml.supplier_flag('Us') if column_value == 'U'
                        }
                      end
                    end
                  end
                }
                xml.catalog_item_castings{
                  for catalog_item_casting in bom.transaction_bom_castings.active
                    if catalog_item_casting.trans_flag =='A'
                      xml.catalog_item_casting do
                        catalog_item_casting.attributes.each_pair{ |column_name,column_value|
                          column_value = format_column(column_value)
                          column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)cost(.*)/ and column_value)
                          column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)amt(.*)/ and column_value)
                          column_value = sprintf( "%0.03f", column_value) if (column_name =~ /(.*)wt(.*)/ and column_value and column_name != 'billed_wt_flag')
                          column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)rate(.*)/ and column_value)
                          xml.tag!(column_name, column_value)
                          xml.supplier_flag('Vendor') if column_value == 'V'
                        }
                      end
                    end
                  end
                }
                xml.catalog_item_findings{
                  for catalog_item_finding in bom.transaction_bom_findings.active
                    if catalog_item_finding.trans_flag =='A'
                      xml.catalog_item_finding do
                        catalog_item_finding.attributes.each_pair{ |column_name,column_value|
                          column_value = format_column(column_value)
                          column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)cost(.*)/ and column_value)
                          column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)amt(.*)/ and column_value)
                          column_value = sprintf( "%0.03f", column_value) if (column_name =~ /(.*)wt(.*)/ and column_value and column_name != 'billed_wt_flag')
                          column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)rate(.*)/ and column_value)
                          xml.tag!(column_name, column_value)
                          xml.supplier_flag('Vendor') if column_value == 'V'
                        }
                      end
                    end
                  end
                }
                xml.catalog_item_stones{
                  for catalog_item_stone in bom.transaction_bom_stones.active
                    if catalog_item_stone.trans_flag =='A'
                      xml.catalog_item_stone do
                        catalog_item_stone.attributes.each_pair{ |column_name,column_value|
                          column_value = format_column(column_value)
                          column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)cost(.*)/ and column_value)
                          column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)amt(.*)/ and column_value)
                          column_value = sprintf( "%0.03f", column_value) if (column_name =~ /(.*)wt(.*)/ and column_value and column_name != 'billed_wt_flag')
                          column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)rate(.*)/ and column_value)
                          xml.tag!(column_name, column_value)
                          xml.supplier_flag('Us') if column_value == 'U'
                        }
                      end
                    end
                  end
                }
                xml.catalog_item_others{
                  for catalog_item_other in bom.transaction_bom_others.active
                    if catalog_item_other.trans_flag =='A'
                      xml.catalog_item_other do
                        catalog_item_other.attributes.each_pair{ |column_name,column_value|
                          column_value = format_column(column_value)
                          column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)cost(.*)/ and column_value)
                          column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)amt(.*)/ and column_value)
                          column_value = sprintf( "%0.03f", column_value) if (column_name =~ /(.*)wt(.*)/ and column_value and column_name != 'billed_wt_flag')
                          column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)rate(.*)/ and column_value)
                          xml.tag!(column_name, column_value)
                        }
                      end
                    end
                  end
                }
              end
            end
          end
        end
      }
    end
  end
}
