class Item::JewelLib
  include General

  def self.import_site_data_excelx(worksheet)
    worksheet.default_sheet = worksheet.sheets.first
    end_value=worksheet.last_row
    start_value_row=worksheet.first_row
    start_value_column=worksheet.first_column
    end_value_col=worksheet.last_column 
    begin
      #  worksheet.each_with_index {|row,row_index| 
      start_value_row.upto(end_value) {|row| 
        case row
        when 1..2
        else
          catalog_item_id=0; catalog_item_category_id=0;catalog_item_c_f_1=0;catalog_item_c_f_2=0;catalog_item_s_d=0;catalog_item_extension=0
          meta_tag='';text='';catalog_item_casting=0;catalog_item=''
          start_value_column.upto(end_value_col){|col| 
            cell_value = worksheet.cell(row,col) if worksheet.cell(row,col)
            cell_value='' if !cell_value
            #            puts '****'+cell_value if worksheet.cell(row,col)
            case col
            when 1
              catalog_item_category = Item::CatalogItemCategory.find_or_create_by_code(:code => cell_value, :name => cell_value)
              catalog_item_category.save
              catalog_item_category_id = catalog_item_category.id
              meta_tag += cell_value + ' '
            when 2 #item category
              catalog_item = Item::CatalogItem.find_or_create_by_web_code(:catalog_item_category_id=>catalog_item_category_id,:web_code => cell_value, :store_code=>cell_value, :name => cell_value)
              catalog_item.purchase_description=cell_value
              catalog_item.sale_description=cell_value
              meta_tag += cell_value + ' '
              catalog_item.save
              catalog_item_id = catalog_item.id
            when 4..5,17,18,19,23#Catalog Item Casting
              catalog_item_casting=Item::CatalogItemCasting.find_or_create_by_catalog_item_id(:catalog_item_id=>catalog_item_id,:company_id=>1) if col==4
              catalog_item_casting.company_id=1 if col==4
              catalog_item_casting.catalog_item_id=catalog_item_id
              catalog_item_casting.qty=1
              catalog_item_casting.metal_type = cell_value if col==4 
              catalog_item_casting.metal_color = cell_value if col==5 
              catalog_item_extension.gold_base_rate=cell_value  if (col==17 and cell_value!='(blank)'and cell_value!='' and cell_value!=0)
              catalog_item_casting.finished_wt = cell_value if (col==18 and cell_value!='(blank)'and cell_value!='' and cell_value!=0)#finished wt
              catalog_item_casting.wt = cell_value if(col==19 and cell_value!='(blank)'and cell_value!='' and cell_value!=0) #net gold wt
              catalog_item_casting.total_wt = cell_value if(col==19 and cell_value!='(blank)'and cell_value!='' and cell_value!=0)#net gold_wt
              catalog_item_casting.total_cost=cell_value if (col==23 and cell_value!='(blank)'and cell_value!='' and cell_value!=0)
              catalog_item_extension.casting_cost=cell_value if (col==23 and cell_value!='(blank)'and cell_value!='' and cell_value!=0)
              catalog_item_casting.save
              catalog_item_extension.save if (col==17 || col==23)
            when 14,20,22#extension
              catalog_item_extension=Item::CatalogItemExtension.find_or_create_by_catalog_item_id(:catalog_item_id=>catalog_item_id,:company_id=>1) if col==14
              catalog_item_extension.catalog_item_id=catalog_item_id if col==14
              catalog_item_extension.company_id=1  if col==14
              catalog_item_extension.diamond_qty= cell_value if (col==14 and cell_value!='(blank)' and cell_value!='' and cell_value!=0 and catalog_item_s_d.stone_type=='DIAM')
              catalog_item_extension.color_stone_qty= cell_value if (col==14 and cell_value!='(blank)' and cell_value!='' and cell_value!=0 and catalog_item_s_d.stone_type!='DIAM')              #total_diam
              #              catalog_item_extension.wt = cell_value if col==13
              #              catalog_item_extension.gold_base_rate = cell_value if (col==19 and cell_value!='(blank)')#gold_rate
              #              catalog_item_extension.gold_total_rate = cell_value if (col==21 and cell_value!='(blank)')#total_gold_rate
              if cell_value==0.00
                cell_value=''
              end
              catalog_item_casting.remarks = cell_value if (col==20 and cell_value!='(blank)'and cell_value!='') #gold rate
              catalog_item_casting.cost = cell_value if (col==22 and cell_value!='(blank)'and cell_value!='') #total_gold_rate
              catalog_item_casting.casting_cost = cell_value if (col==22 and cell_value!='(blank)'and cell_value!=''  and cell_value!=0) #total_gold_rate
              catalog_item_casting.save if (col==20 ||col==22)
              #              catalog_item_extension.casting_cost=cell_value if (col==22 and cell_value!='(blank)'and cell_value!=''  and cell_value!=0) 
              catalog_item_extension.save if col==14
            when 6..13,15,16 #Catalog Item Diamond
              catalog_item_s_d =Item::CatalogItemDiamond.new  if(col==6 and cell_value=='DIAM')
              catalog_item_s_d =Item::CatalogItemStone.new  if (col==6 and cell_value!='DIAM')
              catalog_item_s_d.catalog_item_id =catalog_item_id
              catalog_item_s_d.company_id=1 if col==6
              catalog_item_s_d.stone_type= cell_value if col==6  #stone_type
              catalog_item_s_d.stone_shape= cell_value if col==7  #shape
              catalog_item_s_d.stone_quality= cell_value if col==8  #quality
              catalog_item_s_d.color_to= cell_value if col==9  #color
              catalog_item_s_d.color_from= cell_value if col==9 #color
              catalog_item_s_d.qty= cell_value.to_i if col==11  #diam_qty
              catalog_item_s_d.wt= cell_value if col==10 #diam ptr
              catalog_item_s_d.cost= cell_value if col==13 # diam rate
              #              catalog_item_s_d.total_wt= cell_value if col==15  #total cts
              catalog_item_s_d.total_wt= catalog_item_s_d.qty * catalog_item_s_d.wt  if (catalog_item_s_d.qty and catalog_item_s_d.wt) if col==12
              catalog_item_s_d.total_cost= catalog_item_s_d.total_wt * catalog_item_s_d.cost  if (catalog_item_s_d.total_wt and catalog_item_s_d.cost) if col==13
              catalog_item_extension.diamond_cost= cell_value if  (col==16 and cell_value!='(blank)' and cell_value!='' and catalog_item_s_d.stone_type=='DIAM')
              catalog_item_extension.color_stone_cost= cell_value if  (col==16 and cell_value!='(blank)' and cell_value!='' and catalog_item_s_d.stone_type!='DIAM')
              catalog_item_s_d.save
              catalog_item_extension.save if col==14 #total diam
            when 24..29 #casting/finding
              catalog_item_c_f_1 =Item::CatalogItemFinding.new  if col==24
              catalog_item_c_f_1.company_id=1 if col==24
              catalog_item_c_f_1.catalog_item_id =catalog_item_id
              catalog_item_c_f_1.qty= cell_value if(col==24 and cell_value!='(blank)')#qty1
              catalog_item_c_f_1.wt= cell_value if col==25 #wt1
              catalog_item_c_f_1.cost= cell_value if col==26 #rate1
              catalog_item_c_f_1.remarks='POST'
              catalog_item_c_f_1.cast_cd='POST'
              catalog_item_c_f_1.total_cost= (catalog_item_c_f_1.qty * catalog_item_c_f_1.cost ) if (catalog_item_c_f_1.qty and catalog_item_c_f_1.cost)
              catalog_item_c_f_1.total_wt= (catalog_item_c_f_1.qty * catalog_item_c_f_1.wt ) if (catalog_item_c_f_1.qty and catalog_item_c_f_1.wt)
              catalog_item_c_f_1.finding_cost= (catalog_item_c_f_1.total_wt * catalog_item_c_f_1.cost) if (col==25 and catalog_item_c_f_1.total_wt and catalog_item_c_f_1.cost )#rate1
              catalog_item_c_f_2 =Item::CatalogItemFinding.new  if col==27
              catalog_item_c_f_2.catalog_item_id =catalog_item_id if col==27
              catalog_item_c_f_2.company_id=1 if col==27
              catalog_item_c_f_2.qty= cell_value if (col==27 and cell_value!='(blank)') #qty2
              catalog_item_c_f_2.wt= cell_value if col==28 #wt2
              catalog_item_c_f_2.cost= cell_value if col==29 #rate2
              catalog_item_c_f_2.remarks='EAR NUT' if col==27
              catalog_item_c_f_2.cast_cd='EAR NUT' if col==27
              catalog_item_c_f_2.total_cost= catalog_item_c_f_2.qty * catalog_item_c_f_2.cost  if (catalog_item_c_f_2.qty and catalog_item_c_f_2.cost) if col==29
              catalog_item_c_f_2.total_wt= catalog_item_c_f_2.qty * catalog_item_c_f_2.wt  if (catalog_item_c_f_2.qty and catalog_item_c_f_2.wt) if col==29
              catalog_item_c_f_2.finding_cost= (catalog_item_c_f_2.total_wt * catalog_item_c_f_2.cost) if (col==29 and catalog_item_c_f_2.total_wt and catalog_item_c_f_2.cost )#rate1
              catalog_item_c_f_2.save if col>=27
              catalog_item_c_f_1.save
            when 30
              catalog_item_extension.finding_cost=cell_value if(col==30 and cell_value!='(blank)' and cell_value!='' and cell_value!=0)
              catalog_item_extension.save
            when 31# Calulation of setting charge for diamond
              catalog_item_s_d.labor=(cell_value/catalog_item_extension.diamond_qty) if (catalog_item_s_d.qty and cell_value!='(blank)' and cell_value!=''and catalog_item_extension.diamond_qty and catalog_item_extension.diamond_qty!=0.00 and catalog_item_s_d.stone_type=='DIAM')
              catalog_item_s_d.labor=(cell_value/catalog_item_extension.color_stone_qty) if (catalog_item_s_d.qty and cell_value!='(blank)' and cell_value!=''and catalog_item_extension.color_stone_qty and catalog_item_extension.color_stone_qty!=0.00 and catalog_item_s_d.stone_type!='DIAM')
              if !catalog_item_s_d.labor
                catalog_item_s_d.labor= Item::CatalogItemDiamond.find_by_catalog_item_id(catalog_item_id).labor  if catalog_item_s_d.stone_type=='DIAM'
                catalog_item_s_d.labor= Item::CatalogItemStone.find_by_catalog_item_id(catalog_item_id).labor  if catalog_item_s_d.stone_type!='DIAM'
              end
              catalog_item_s_d.setting_cost=catalog_item_s_d.labor*catalog_item_s_d.qty if (catalog_item_s_d.labor and catalog_item_s_d.qty)
              catalog_item_s_d.save
              catalog_item_extension.settinglabor_cost=0 if !catalog_item_extension.settinglabor_cost
              catalog_item_extension.settinglabor_cost +=catalog_item_s_d.setting_cost  if (catalog_item_s_d.setting_cost )
              catalog_item_extension.save
            when 32 #item Other
              if cell_value==0.00
                cell_value=''
              end
              catalog_item_other = Item::CatalogItemOther.find_or_create_by_catalog_item_id(:catalog_item_id=>catalog_item_id,:company_id=>1,:other_code=>'LABOR') if col==32
              catalog_item_other.catalog_item_id = catalog_item_id
              catalog_item_other.company_id=1
              catalog_item_other.other_code='LABOR'
              catalog_item_other.qty=1
              catalog_item_other.cost= cell_value if (col==32 and cell_value!='(blank)' and cell_value!='')
              catalog_item_other.total_cost= cell_value if (col==32 and cell_value!='(blank)' and cell_value!='')
              catalog_item_other.save
              catalog_item_extension.other_cost=catalog_item_other.total_cost
              catalog_item_extension.total_cost= (catalog_item_extension.settinglabor_cost || 0 )+(catalog_item_extension.other_cost || 0 )+ (catalog_item_extension.casting_cost || 0) + (catalog_item_extension.finding_cost || 0) + (catalog_item_extension.diamond_cost || 0)
              #              catalog_item_extension.total_cost=(catalog_item_extension.other_cost || 0 )+ (catalog_item_extension.casting_cost || 0) + (catalog_item_extension.diamond_cost || 0)
              catalog_item_extension.save
            when 33 #item Price
              puts cell_value
              catalog_item.cost= cell_value if (col==33 and cell_value!='(blank)' and cell_value!='' and cell_value!=0)
              catalog_item.meta_tag=meta_tag
              catalog_item.save  
            
            else
            end
          }
        end
      } 
      #  rescue ActiveRecord::StatementInvalid 
      #    rescue StandardError =>ex
      #      puts "An error occurred"
      #      return 'error'
    end
    return 'success'
  end
  
  def self.import_site_data_excelx_new(worksheet)
    worksheet.default_sheet = worksheet.sheets.first
    end_value=worksheet.last_row
    start_value_row=worksheet.first_row
    start_value_column=worksheet.first_column
    end_value_col=worksheet.last_column 
    begin
      #  worksheet.each_with_index {|row,row_index| 
      start_value_row.upto(end_value) {|row| 
        case row
        when 1..2
        else
          catalog_item_id=0; catalog_item_category_id=0;catalog_item_c_f_1=0;catalog_item_c_f_2=0;catalog_item_s_d=0;catalog_item_extension=0
          meta_tag='';text='';catalog_item_casting=0;catalog_item=''
          start_value_column.upto(end_value_col){|col| 
            cell_value = worksheet.cell(row,col) if worksheet.cell(row,col)
            cell_value='' if !cell_value
            #            puts '****'+cell_value if worksheet.cell(row,col)
            case col
            when 1
              catalog_item_category = Item::CatalogItemCategory.find_or_create_by_code(:code => cell_value, :name => cell_value)
              catalog_item_category.save
              catalog_item_category_id = catalog_item_category.id
              meta_tag += cell_value + ' '
            when 2 #item category
              catalog_item = Item::CatalogItem.find_or_create_by_web_code(:catalog_item_category_id=>catalog_item_category_id,:web_code => cell_value, :store_code=>cell_value, :name => cell_value)
              catalog_item.purchase_description=cell_value
              catalog_item.sale_description=cell_value
              meta_tag += cell_value + ' '
              catalog_item.save
              catalog_item_id = catalog_item.id
            when 4..5,17,18,19,23#Catalog Item Casting
              catalog_item_casting=Item::CatalogItemCasting.find_or_create_by_catalog_item_id(:catalog_item_id=>catalog_item_id,:company_id=>1) if col==4
              catalog_item_casting.company_id=1 if col==4
              catalog_item_casting.catalog_item_id=catalog_item_id
              catalog_item_casting.qty=1
              catalog_item_casting.metal_type = cell_value if col==4 
              catalog_item_casting.metal_color = cell_value if col==5 
              catalog_item_extension.gold_base_rate=cell_value  if (col==17 and cell_value!='(blank)'and cell_value!='' and cell_value!=0)
              catalog_item_casting.finished_wt = cell_value if (col==18 and cell_value!='(blank)'and cell_value!='' and cell_value!=0)#finished wt
              catalog_item_casting.wt = cell_value if(col==19 and cell_value!='(blank)'and cell_value!='' and cell_value!=0) #net gold wt
              catalog_item_casting.total_wt = cell_value if(col==19 and cell_value!='(blank)'and cell_value!='' and cell_value!=0)#net gold_wt
              catalog_item_casting.total_cost=cell_value if (col==23 and cell_value!='(blank)'and cell_value!='' and cell_value!=0)
              catalog_item_extension.casting_cost=cell_value if (col==23 and cell_value!='(blank)'and cell_value!='' and cell_value!=0)
              catalog_item_casting.save
              catalog_item_extension.save if (col==17 || col==23)
            when 14,20,22#extension
              catalog_item_extension=Item::CatalogItemExtension.find_or_create_by_catalog_item_id(:catalog_item_id=>catalog_item_id,:company_id=>1) if col==14
              catalog_item_extension.catalog_item_id=catalog_item_id if col==14
              catalog_item_extension.company_id=1  if col==14
              catalog_item_extension.diamond_qty= cell_value if (col==14 and cell_value!='(blank)' and cell_value!='' and cell_value!=0 and catalog_item_s_d.stone_type=='DIAM')
              catalog_item_extension.color_stone_qty= cell_value if (col==14 and cell_value!='(blank)' and cell_value!='' and cell_value!=0 and catalog_item_s_d.stone_type!='DIAM')              #total_diam
              #              catalog_item_extension.wt = cell_value if col==13
              #              catalog_item_extension.gold_base_rate = cell_value if (col==19 and cell_value!='(blank)')#gold_rate
              #              catalog_item_extension.gold_total_rate = cell_value if (col==21 and cell_value!='(blank)')#total_gold_rate
              if cell_value==0.00
                cell_value=''
              end
              catalog_item_casting.remarks = cell_value if (col==20 and cell_value!='(blank)'and cell_value!='') #gold rate
              catalog_item_casting.cost = cell_value if (col==22 and cell_value!='(blank)'and cell_value!='') #total_gold_rate
              catalog_item_casting.casting_cost = cell_value if (col==22 and cell_value!='(blank)'and cell_value!=''  and cell_value!=0) #total_gold_rate
              catalog_item_casting.save if (col==20 ||col==22)
              #              catalog_item_extension.casting_cost=cell_value if (col==22 and cell_value!='(blank)'and cell_value!=''  and cell_value!=0) 
              catalog_item_extension.save if col==14
            when 6..13,15,16 #Catalog Item Diamond
              catalog_item_s_d =Item::CatalogItemDiamond.new  if(col==6 and cell_value=='DIAM')
              catalog_item_s_d =Item::CatalogItemStone.new  if (col==6 and cell_value!='DIAM')
              catalog_item_s_d.catalog_item_id =catalog_item_id
              catalog_item_s_d.company_id=1 if col==6
              catalog_item_s_d.stone_type= cell_value if col==6  #stone_type
              catalog_item_s_d.stone_shape= cell_value if col==7  #shape
              catalog_item_s_d.stone_quality= cell_value if col==8  #quality
              catalog_item_s_d.color_to= cell_value if col==9  #color
              catalog_item_s_d.color_from= cell_value if col==9 #color
              catalog_item_s_d.qty= cell_value.to_i if col==11  #diam_qty
              catalog_item_s_d.wt= cell_value if col==10 #diam ptr
              catalog_item_s_d.cost= cell_value if col==13 # diam rate
              #              catalog_item_s_d.total_wt= cell_value if col==15  #total cts
              catalog_item_s_d.total_wt= catalog_item_s_d.qty * catalog_item_s_d.wt  if (catalog_item_s_d.qty and catalog_item_s_d.wt) if col==12
              catalog_item_s_d.total_cost= catalog_item_s_d.total_wt * catalog_item_s_d.cost  if (catalog_item_s_d.total_wt and catalog_item_s_d.cost) if col==13
              catalog_item_extension.diamond_cost= cell_value if  (col==16 and cell_value!='(blank)' and cell_value!='' and catalog_item_s_d.stone_type=='DIAM')
              catalog_item_extension.color_stone_cost= cell_value if  (col==16 and cell_value!='(blank)' and cell_value!='' and catalog_item_s_d.stone_type!='DIAM')
              catalog_item_s_d.save
              catalog_item_extension.save if col==14 #total diam
            when 24..27 #casting/finding
              catalog_item_c_f_1 =Item::CatalogItemFinding.new  if col==24
              catalog_item_c_f_1.company_id=1 if col==24
              catalog_item_c_f_1.catalog_item_id =catalog_item_id
              max_serial_no = Item::CatalogItemFinding.maximum(:serial_no,
                :conditions =>[ "catalog_item_id=?",catalog_item_id])
              serial_no = max_serial_no ? max_serial_no.to_i + 1:100
              catalog_item_c_f_1.serial_no=serial_no if col==24
              catalog_item_c_f_1.cast_cd=cell_value if col==24
              catalog_item_c_f_1.qty= cell_value if(col==25 and cell_value!='(blank)')#qty1
              catalog_item_c_f_1.wt= cell_value if col==26 #wt1
              catalog_item_c_f_1.cost= cell_value if col==27 #rate1
              catalog_item_c_f_1.total_cost= (catalog_item_c_f_1.qty * catalog_item_c_f_1.cost ) if (catalog_item_c_f_1.qty and catalog_item_c_f_1.cost)
              catalog_item_c_f_1.total_wt= (catalog_item_c_f_1.qty * catalog_item_c_f_1.wt ) if (catalog_item_c_f_1.qty and catalog_item_c_f_1.wt)
              catalog_item_c_f_1.finding_cost= (catalog_item_c_f_1.total_wt * cell_value.to_f) if (col==27 and catalog_item_c_f_1.total_wt and cell_value)#rate1
              catalog_item_c_f_1.save
            when 28
              catalog_item_extension.finding_cost=cell_value if(col==28 and cell_value!='(blank)' and cell_value!='' and cell_value!=0)
              catalog_item_extension.save
            when 29# Calulation of setting charge for diamond
              catalog_item_s_d.labor=(cell_value.to_f/catalog_item_extension.diamond_qty) if (catalog_item_s_d.qty and cell_value!='(blank)' and cell_value!=''and catalog_item_extension.diamond_qty and catalog_item_extension.diamond_qty!=0.00 and catalog_item_s_d.stone_type=='DIAM')
              catalog_item_s_d.labor=(cell_value.to_f/catalog_item_extension.color_stone_qty) if (catalog_item_s_d.qty and cell_value!='(blank)' and cell_value!=''and catalog_item_extension.color_stone_qty and catalog_item_extension.color_stone_qty!=0.00 and catalog_item_s_d.stone_type!='DIAM')
              if !catalog_item_s_d.labor
                catalog_item_s_d.labor= Item::CatalogItemDiamond.find_by_catalog_item_id(catalog_item_id).labor  if catalog_item_s_d.stone_type=='DIAM'
                catalog_item_s_d.labor= Item::CatalogItemStone.find_by_catalog_item_id(catalog_item_id).labor  if catalog_item_s_d.stone_type!='DIAM'
              end
              catalog_item_s_d.setting_cost=catalog_item_s_d.labor*catalog_item_s_d.qty if (catalog_item_s_d.labor and catalog_item_s_d.qty)
              catalog_item_s_d.save
              catalog_item_extension.settinglabor_cost=0 if !catalog_item_extension.settinglabor_cost
              catalog_item_extension.settinglabor_cost +=catalog_item_s_d.setting_cost  if (catalog_item_s_d.setting_cost )
              catalog_item_extension.save
            when 30 #item Other
              if cell_value==0.00
                cell_value=''
              end
              catalog_item_other = Item::CatalogItemOther.find_or_create_by_catalog_item_id(:catalog_item_id=>catalog_item_id,:company_id=>1,:other_code=>'LABOR') if col==30
              catalog_item_other.catalog_item_id = catalog_item_id
              catalog_item_other.company_id=1
              catalog_item_other.other_code='LABOR'
              catalog_item_other.qty=1
              catalog_item_other.cost= cell_value if (col==30 and cell_value!='(blank)' and cell_value!='')
              catalog_item_other.total_cost= cell_value if (col==30 and cell_value!='(blank)' and cell_value!='')
              catalog_item_other.save
              catalog_item_extension.other_cost=catalog_item_other.total_cost
              catalog_item_extension.total_cost= (catalog_item_extension.settinglabor_cost || 0 )+(catalog_item_extension.other_cost || 0 )+ (catalog_item_extension.casting_cost || 0) + (catalog_item_extension.finding_cost || 0) + (catalog_item_extension.diamond_cost || 0)
              #              catalog_item_extension.total_cost=(catalog_item_extension.other_cost || 0 )+ (catalog_item_extension.casting_cost || 0) + (catalog_item_extension.diamond_cost || 0)
              catalog_item_extension.save
            when 31..32 #item Price
              puts cell_value
              catalog_item.cost= cell_value if (col==31 and cell_value!='(blank)' and cell_value!='' and cell_value!=0)
              catalog_item.meta_tag=meta_tag
              catalog_item.image_thumnail=catalog_item.image_normal=catalog_item.image_enlarge=catalog_item.image_small=cell_value if col==32
              catalog_item.save  
            
            else
            end
          }
        end
      } 
      #  rescue ActiveRecord::StatementInvalid 
      #    rescue StandardError =>ex
      #      puts "An error occurred"
      #      return 'error'
    end
    return 'success'
  end 
  
  def self.import_site_data(worksheet)
    text=''
    begin
      worksheet.each_with_index {|row,row_index| 
        case row_index
        when 0..1
        else
          catalog_item_id=0; catalog_item_category_id=0;catalog_item_c_f_1=0;catalog_item_c_f_2=0;catalog_item_s_d=0;catalog_item_extension=0
          meta_tag='';text='';catalog_item_casting=0;catalog_item=''
          row.each_with_index{|cell,cell_index| 
            cell_value = cell.to_s('latin1') if cell
            cell_value='' if !cell_value
            case cell_index
            when 0 #item category
              catalog_item_category = Item::CatalogItemCategory.find_or_create_by_code(:code => cell_value, :name => cell_value)
              catalog_item_category.save
              catalog_item_category_id = catalog_item_category.id
              meta_tag += cell_value + ' '
            when 1 #item category
              catalog_item = Item::CatalogItem.find_or_create_by_web_code(:catalog_item_category_id=>catalog_item_category_id,:web_code => cell_value, :store_code=>cell_value, :name => cell_value)
              catalog_item.purchase_description=cell_value
              catalog_item.sale_description=cell_value
              meta_tag += cell_value + ' '
              catalog_item.save
              catalog_item_id = catalog_item.id
            when 3..4,16,17,18,22#Catalog Item Casting
              catalog_item_casting=Item::CatalogItemCasting.find_or_create_by_catalog_item_id(:catalog_item_id=>catalog_item_id,:company_id=>1) if cell_index==3
              catalog_item_casting.company_id=1 if cell_index==3
              catalog_item_casting.catalog_item_id=catalog_item_id
              catalog_item_casting.qty=1
              catalog_item_casting.metal_type = cell_value if cell_index==3 
              catalog_item_casting.metal_color = cell_value if cell_index==4 
              catalog_item_extension.gold_base_rate=cell_value  if (cell_index==16 and cell_value!='(blank)'and cell_value!='' and cell_value!=0)
              catalog_item_casting.finished_wt = cell_value if (cell_index==17 and cell_value!='(blank)'and cell_value!='' and cell_value!=0)#finished wt
              catalog_item_casting.wt = cell_value if(cell_index==18 and cell_value!='(blank)'and cell_value!='' and cell_value!=0) #net gold wt
              catalog_item_casting.total_wt = cell_value if(cell_index==18 and cell_value!='(blank)'and cell_value!='' and cell_value!=0)#net gold_wt
              catalog_item_casting.total_cost=cell_value if (cell_index==22 and cell_value!='(blank)'and cell_value!='' and cell_value!=0)
              catalog_item_extension.casting_cost=cell_value if (cell_index==22 and cell_value!='(blank)'and cell_value!='' and cell_value!=0)
              catalog_item_casting.save
              catalog_item_extension.save if (cell_index==18 || cell_index==22)
            when 13,19,21#extension
              catalog_item_extension=Item::CatalogItemExtension.find_or_create_by_catalog_item_id(:catalog_item_id=>catalog_item_id,:company_id=>1) if cell_index==13
              catalog_item_extension.catalog_item_id=catalog_item_id if cell_index==13
              catalog_item_extension.company_id=1  if cell_index==13
              catalog_item_extension.diamond_qty= cell_value if (cell_index==13 and cell_value!='(blank)' and cell_value!='' and cell_value!=0 and catalog_item_s_d.stone_type=='DIAM')
              catalog_item_extension.color_stone_qty= cell_value if (cell_index==13 and cell_value!='(blank)' and cell_value!='' and cell_value!=0 and catalog_item_s_d.stone_type!='DIAM')              #total_diam
              #              catalog_item_extension.wt = cell_value if cell_index==13
              #              catalog_item_extension.gold_base_rate = cell_value if (cell_index==19 and cell_value!='(blank)')#gold_rate
              #              catalog_item_extension.gold_total_rate = cell_value if (cell_index==21 and cell_value!='(blank)')#total_gold_rate
              if cell_value==0.00
                cell_value=''
              end
              catalog_item_casting.remarks = cell_value if (cell_index==19 and cell_value!='(blank)'and cell_value!='') #gold rate
              catalog_item_casting.cost = cell_value if (cell_index==21 and cell_value!='(blank)'and cell_value!='') #total_gold_rate
              catalog_item_casting.casting_cost = cell_value if (cell_index==21 and cell_value!='(blank)'and cell_value!=''  and cell_value!=0) #total_gold_rate
              catalog_item_casting.save if (cell_index==19 ||cell_index==21)
              #              catalog_item_extension.casting_cost=cell_value if (cell_index==22 and cell_value!='(blank)'and cell_value!=''  and cell_value!=0) 
              catalog_item_extension.save if cell_index==13
            when 5..12,14,15#Catalog Item Diamond
              catalog_item_s_d =Item::CatalogItemDiamond.new  if(cell_index==5 and cell_value=='DIAM')
              catalog_item_s_d =Item::CatalogItemStone.new  if (cell_index==5 and cell_value!='DIAM')
              catalog_item_s_d.catalog_item_id =catalog_item_id
              catalog_item_s_d.company_id=1 if cell_index==5
              catalog_item_s_d.stone_type= cell_value if cell_index==5  #stone_type
              catalog_item_s_d.stone_shape= cell_value if cell_index==6  #shape
              catalog_item_s_d.stone_quality= cell_value if cell_index==7  #quality
              catalog_item_s_d.color_to= cell_value if cell_index==8  #color
              catalog_item_s_d.color_from= cell_value if cell_index==9 #color
              catalog_item_s_d.qty= cell_value.to_i if cell_index==10  #diam_qty
              catalog_item_s_d.wt= cell_value if cell_index==9 #diam ptr
              catalog_item_s_d.cost= cell_value if cell_index==12 # diam rate
              #              catalog_item_s_d.total_wt= cell_value if cell_index==15  #total cts
              catalog_item_s_d.total_wt= catalog_item_s_d.qty * catalog_item_s_d.wt  if (catalog_item_s_d.qty and catalog_item_s_d.wt) if cell_index==11
              catalog_item_s_d.total_cost= catalog_item_s_d.total_wt * catalog_item_s_d.cost  if (catalog_item_s_d.total_wt and catalog_item_s_d.cost) if cell_index==12
              catalog_item_extension.diamond_cost= cell_value if  (cell_index==15 and cell_value!='(blank)' and cell_value!='' and catalog_item_s_d.stone_type=='DIAM')
              catalog_item_extension.color_stone_cost= cell_value if  (cell_index==15 and cell_value!='(blank)' and cell_value!='' and catalog_item_s_d.stone_type!='DIAM')
              catalog_item_s_d.save
              catalog_item_extension.save if cell_index==13 #total diam
            when 23..28 #casting/finding
              catalog_item_c_f_1 =Item::CatalogItemFinding.new  if cell_index==23
              catalog_item_c_f_1.company_id=1 if cell_index==23
              catalog_item_c_f_1.catalog_item_id =catalog_item_id
              catalog_item_c_f_1.qty= cell_value if(cell_index==23 and cell_value!='(blank)')#qty1
              catalog_item_c_f_1.wt= cell_value if cell_index==24 #wt1
              catalog_item_c_f_1.cost= cell_value if cell_index==25 #rate1
              catalog_item_c_f_1.remarks='POST'
              catalog_item_c_f_1.cast_cd='POST'
              catalog_item_c_f_1.total_cost= (catalog_item_c_f_1.qty * catalog_item_c_f_1.cost ) if (catalog_item_c_f_1.qty and catalog_item_c_f_1.cost)
              catalog_item_c_f_1.total_wt= (catalog_item_c_f_1.qty * catalog_item_c_f_1.wt ) if (catalog_item_c_f_1.qty and catalog_item_c_f_1.wt)
              catalog_item_c_f_1.finding_cost= (catalog_item_c_f_1.total_wt * catalog_item_c_f_1.cost) if (cell_index==24 and catalog_item_c_f_1.total_wt and catalog_item_c_f_1.cost )#rate1
              catalog_item_c_f_2 =Item::CatalogItemFinding.new  if cell_index==26
              catalog_item_c_f_2.catalog_item_id =catalog_item_id if cell_index==26
              catalog_item_c_f_2.company_id=1 if cell_index==26
              catalog_item_c_f_2.qty= cell_value if (cell_index==26 and cell_value!='(blank)') #qty2
              catalog_item_c_f_2.wt= cell_value if cell_index==27 #wt2
              catalog_item_c_f_2.cost= cell_value if cell_index==28 #rate2
              catalog_item_c_f_2.remarks='EAR NUT' if cell_index==26
              catalog_item_c_f_2.cast_cd='EAR NUT' if cell_index==26
              catalog_item_c_f_2.total_cost= catalog_item_c_f_2.qty * catalog_item_c_f_2.cost  if (catalog_item_c_f_2.qty and catalog_item_c_f_2.cost) if cell_index==28
              catalog_item_c_f_2.total_wt= catalog_item_c_f_2.qty * catalog_item_c_f_2.wt  if (catalog_item_c_f_2.qty and catalog_item_c_f_2.wt) if cell_index==28
              catalog_item_c_f_2.finding_cost= (catalog_item_c_f_2.total_wt * catalog_item_c_f_2.cost) if (cell_index==28 and catalog_item_c_f_2.total_wt and catalog_item_c_f_2.cost )#rate1
              catalog_item_c_f_2.save if cell_index>=26
              catalog_item_c_f_1.save
            when 29
              catalog_item_extension.finding_cost=cell_value if(cell_index==29 and cell_value!='(blank)' and cell_value!='' and cell_value!=0)
              catalog_item_extension.save
            when 30# Calulation of setting charge for diamond
              catalog_item_s_d.labor=(cell_value.to_f/catalog_item_extension.diamond_qty) if (catalog_item_s_d.qty and cell_value!='(blank)' and cell_value!=''and catalog_item_extension.diamond_qty and catalog_item_extension.diamond_qty!=0.00 and catalog_item_s_d.stone_type=='DIAM')
              catalog_item_s_d.labor=(cell_value.to_f/catalog_item_extension.color_stone_qty) if (catalog_item_s_d.qty and cell_value!='(blank)' and cell_value!=''and catalog_item_extension.color_stone_qty and catalog_item_extension.color_stone_qty!=0.00 and catalog_item_s_d.stone_type!='DIAM')
              if !catalog_item_s_d.labor
                catalog_item_s_d.labor= Item::CatalogItemDiamond.find_by_catalog_item_id(catalog_item_id).labor  if catalog_item_s_d.stone_type=='DIAM'
                catalog_item_s_d.labor= Item::CatalogItemStone.find_by_catalog_item_id(catalog_item_id).labor  if catalog_item_s_d.stone_type!='DIAM'
              end
              catalog_item_s_d.setting_cost=catalog_item_s_d.labor*catalog_item_s_d.qty if (catalog_item_s_d.labor and catalog_item_s_d.qty)
              catalog_item_s_d.save
              catalog_item_extension.settinglabor_cost=0 if !catalog_item_extension.settinglabor_cost
              catalog_item_extension.settinglabor_cost +=catalog_item_s_d.setting_cost  if (catalog_item_s_d.setting_cost )
              catalog_item_extension.save
            when 31 #item Other
              if cell_value==0.00
                cell_value=''
              end
              catalog_item_other = Item::CatalogItemOther.find_or_create_by_catalog_item_id(:catalog_item_id=>catalog_item_id,:company_id=>1,:other_code=>'LABOR') if cell_index==31
              catalog_item_other.catalog_item_id = catalog_item_id
              catalog_item_other.company_id=1
              catalog_item_other.other_code='LABOR'
              catalog_item_other.qty=1
              catalog_item_other.cost= cell_value if (cell_index==31 and cell_value!='(blank)' and cell_value!='')
              catalog_item_other.total_cost= cell_value if (cell_index==31 and cell_value!='(blank)' and cell_value!='')
              catalog_item_other.save
              catalog_item_extension.other_cost=catalog_item_other.total_cost
              catalog_item_extension.total_cost= (catalog_item_extension.settinglabor_cost || 0 )+(catalog_item_extension.other_cost || 0 )+ (catalog_item_extension.casting_cost || 0) + (catalog_item_extension.finding_cost || 0) + (catalog_item_extension.diamond_cost || 0)
              #              catalog_item_extension.total_cost=(catalog_item_extension.other_cost || 0 )+ (catalog_item_extension.casting_cost || 0) + (catalog_item_extension.diamond_cost || 0)
              catalog_item_extension.save
            when 32 #item Price
              puts cell_value
              catalog_item.cost= cell_value if (cell_index==32 and cell_value!='(blank)' and cell_value!='' and cell_value!=0)
              catalog_item.meta_tag=meta_tag
              catalog_item.save  
             
            else
            end
          }
        end
      } 
      #  rescue ActiveRecord::StatementInvalid 
      puts text
    rescue StandardError=>ex
      puts "An error occurred"
      return 'error'
    end
    return text
  end
  
  def self.import_site_data_new(worksheet)
    text=''
    begin
      worksheet.each_with_index {|row,row_index| 
        case row_index
        when 0..1
        else
          catalog_item_id=0; catalog_item_category_id=0;catalog_item_c_f_1=0;catalog_item_c_f_2=0;catalog_item_s_d=0;catalog_item_extension=0
          meta_tag='';text='';catalog_item_casting=0;catalog_item=''
          row.each_with_index{|cell,cell_index| 
            cell_value = cell.to_s('latin1') if cell
            cell_value='' if !cell_value
            case cell_index
            when 0 #item category
              catalog_item_category = Item::CatalogItemCategory.find_or_create_by_code(:code => cell_value, :name => cell_value)
              catalog_item_category.save
              catalog_item_category_id = catalog_item_category.id
              meta_tag += cell_value + ' '
            when 1 #item category
              catalog_item = Item::CatalogItem.find_or_create_by_web_code(:catalog_item_category_id=>catalog_item_category_id,:web_code => cell_value, :store_code=>cell_value, :name => cell_value)
              catalog_item.purchase_description=cell_value
              catalog_item.sale_description=cell_value
              meta_tag += cell_value + ' '
              catalog_item.save
              catalog_item_id = catalog_item.id
            when 3..4,16,17,18,22#Catalog Item Casting
              catalog_item_casting=Item::CatalogItemCasting.find_or_create_by_catalog_item_id(:catalog_item_id=>catalog_item_id,:company_id=>1) if cell_index==3
              catalog_item_casting.company_id=1 if cell_index==3
              catalog_item_casting.catalog_item_id=catalog_item_id
              catalog_item_casting.qty=1
              catalog_item_casting.metal_type = cell_value if cell_index==3 
              catalog_item_casting.metal_color = cell_value if cell_index==4 
              catalog_item_extension.gold_base_rate=cell_value  if (cell_index==16 and cell_value!='(blank)'and cell_value!='' and cell_value!=0)
              catalog_item_casting.finished_wt = cell_value if (cell_index==17 and cell_value!='(blank)'and cell_value!='' and cell_value!=0)#finished wt
              catalog_item_casting.wt = cell_value if(cell_index==18 and cell_value!='(blank)'and cell_value!='' and cell_value!=0) #net gold wt
              catalog_item_casting.total_wt = cell_value if(cell_index==18 and cell_value!='(blank)'and cell_value!='' and cell_value!=0)#net gold_wt
              catalog_item_casting.total_cost=cell_value if (cell_index==22 and cell_value!='(blank)'and cell_value!='' and cell_value!=0)
              catalog_item_extension.casting_cost=cell_value if (cell_index==22 and cell_value!='(blank)'and cell_value!='' and cell_value!=0)
              catalog_item_casting.save
              catalog_item_extension.save if (cell_index==18 || cell_index==22)
            when 13,19,21#extension
              catalog_item_extension=Item::CatalogItemExtension.find_or_create_by_catalog_item_id(:catalog_item_id=>catalog_item_id,:company_id=>1) if cell_index==13
              catalog_item_extension.catalog_item_id=catalog_item_id if cell_index==13
              catalog_item_extension.company_id=1  if cell_index==13
              catalog_item_extension.diamond_qty= cell_value if (cell_index==13 and cell_value!='(blank)' and cell_value!='' and cell_value!=0 and catalog_item_s_d.stone_type=='DIAM')
              catalog_item_extension.color_stone_qty= cell_value if (cell_index==13 and cell_value!='(blank)' and cell_value!='' and cell_value!=0 and catalog_item_s_d.stone_type!='DIAM')              #total_diam
              #              catalog_item_extension.wt = cell_value if cell_index==13
              #              catalog_item_extension.gold_base_rate = cell_value if (cell_index==19 and cell_value!='(blank)')#gold_rate
              #              catalog_item_extension.gold_total_rate = cell_value if (cell_index==21 and cell_value!='(blank)')#total_gold_rate
              if cell_value==0.00
                cell_value=''
              end
              catalog_item_casting.remarks = cell_value if (cell_index==19 and cell_value!='(blank)'and cell_value!='') #gold rate
              catalog_item_casting.cost = cell_value if (cell_index==21 and cell_value!='(blank)'and cell_value!='') #total_gold_rate
              catalog_item_casting.casting_cost = cell_value if (cell_index==21 and cell_value!='(blank)'and cell_value!=''  and cell_value!=0) #total_gold_rate
              catalog_item_casting.save if (cell_index==19 ||cell_index==21)
              #              catalog_item_extension.casting_cost=cell_value if (cell_index==22 and cell_value!='(blank)'and cell_value!=''  and cell_value!=0) 
              catalog_item_extension.save if cell_index==13
            when 5..12,14,15#Catalog Item Diamond
              catalog_item_s_d =Item::CatalogItemDiamond.new  if(cell_index==5 and cell_value=='DIAM')
              catalog_item_s_d =Item::CatalogItemStone.new  if (cell_index==5 and cell_value!='DIAM')
              catalog_item_s_d.catalog_item_id =catalog_item_id
              catalog_item_s_d.company_id=1 if cell_index==5
              catalog_item_s_d.stone_type= cell_value if cell_index==5  #stone_type
              catalog_item_s_d.stone_shape= cell_value if cell_index==6  #shape
              catalog_item_s_d.stone_quality= cell_value if cell_index==7  #quality
              catalog_item_s_d.color_to= cell_value if cell_index==8  #color
              catalog_item_s_d.color_from= cell_value if cell_index==9 #color
              catalog_item_s_d.qty= cell_value.to_i if cell_index==10  #diam_qty
              catalog_item_s_d.wt= cell_value if cell_index==9 #diam ptr
              catalog_item_s_d.cost= cell_value if cell_index==12 # diam rate
              #              catalog_item_s_d.total_wt= cell_value if cell_index==15  #total cts
              catalog_item_s_d.total_wt= catalog_item_s_d.qty * catalog_item_s_d.wt  if (catalog_item_s_d.qty and catalog_item_s_d.wt) if cell_index==11
              catalog_item_s_d.total_cost= catalog_item_s_d.total_wt * catalog_item_s_d.cost  if (catalog_item_s_d.total_wt and catalog_item_s_d.cost) if cell_index==12
              catalog_item_extension.diamond_cost= cell_value if  (cell_index==15 and cell_value!='(blank)' and cell_value!='' and catalog_item_s_d.stone_type=='DIAM')
              catalog_item_extension.color_stone_cost= cell_value if  (cell_index==15 and cell_value!='(blank)' and cell_value!='' and catalog_item_s_d.stone_type!='DIAM')
              catalog_item_s_d.save
              catalog_item_extension.save if cell_index==13 #total diam
            when 23..26 #casting/finding
              catalog_item_c_f_1 =Item::CatalogItemFinding.new  if cell_index==23
              catalog_item_c_f_1.company_id=1 if cell_index==23
              catalog_item_c_f_1.catalog_item_id =catalog_item_id
              max_serial_no = Item::CatalogItemFinding.maximum(:serial_no,
                :conditions =>[ "catalog_item_id=?",catalog_item_id])
              serial_no = max_serial_no ? max_serial_no.to_i + 1:100
              catalog_item_c_f_1.serial_no=serial_no if cell_index==23
              catalog_item_c_f_1.cast_cd=cell_value if cell_index==23
              catalog_item_c_f_1.qty= cell_value if(cell_index==24 and cell_value!='(blank)')#qty1
              catalog_item_c_f_1.wt= cell_value if cell_index==25 #wt1
              catalog_item_c_f_1.cost= cell_value if cell_index==26 #rate1
              catalog_item_c_f_1.total_cost= (catalog_item_c_f_1.qty * catalog_item_c_f_1.cost ) if (catalog_item_c_f_1.qty and catalog_item_c_f_1.cost)
              catalog_item_c_f_1.total_wt= (catalog_item_c_f_1.qty * catalog_item_c_f_1.wt ) if (catalog_item_c_f_1.qty and catalog_item_c_f_1.wt)
              catalog_item_c_f_1.finding_cost= (catalog_item_c_f_1.total_wt * cell_value.to_f) if (cell_index==26 and catalog_item_c_f_1.total_wt and cell_value)#rate1
              catalog_item_c_f_1.save
            when 27
              catalog_item_extension.finding_cost=cell_value if(cell_index==27 and cell_value!='(blank)' and cell_value!='' and cell_value!=0)
              catalog_item_extension.save
            when 28# Calulation of setting charge for diamond
              catalog_item_s_d.labor=(cell_value.to_f/catalog_item_extension.diamond_qty) if (catalog_item_s_d.qty and cell_value!='(blank)' and cell_value!=''and catalog_item_extension.diamond_qty and catalog_item_extension.diamond_qty!=0.00 and catalog_item_s_d.stone_type=='DIAM')
              catalog_item_s_d.labor=(cell_value.to_f/catalog_item_extension.color_stone_qty) if (catalog_item_s_d.qty and cell_value!='(blank)' and cell_value!=''and catalog_item_extension.color_stone_qty and catalog_item_extension.color_stone_qty!=0.00 and catalog_item_s_d.stone_type!='DIAM')
              if !catalog_item_s_d.labor
                catalog_item_s_d.labor= Item::CatalogItemDiamond.find_by_catalog_item_id(catalog_item_id).labor  if catalog_item_s_d.stone_type=='DIAM'
                catalog_item_s_d.labor= Item::CatalogItemStone.find_by_catalog_item_id(catalog_item_id).labor  if catalog_item_s_d.stone_type!='DIAM'
              end
              catalog_item_s_d.setting_cost=catalog_item_s_d.labor*catalog_item_s_d.qty if (catalog_item_s_d.labor and catalog_item_s_d.qty)
              catalog_item_s_d.save
              catalog_item_extension.settinglabor_cost=0 if !catalog_item_extension.settinglabor_cost
              catalog_item_extension.settinglabor_cost +=catalog_item_s_d.setting_cost  if (catalog_item_s_d.setting_cost )
              catalog_item_extension.save
            when 29 #item Other
              if cell_value==0.00
                cell_value=''
              end
              catalog_item_other = Item::CatalogItemOther.find_or_create_by_catalog_item_id(:catalog_item_id=>catalog_item_id,:company_id=>1,:other_code=>'LABOR') if cell_index==29
              catalog_item_other.catalog_item_id = catalog_item_id
              catalog_item_other.company_id=1
              catalog_item_other.other_code='LABOR'
              catalog_item_other.qty=1
              catalog_item_other.cost= cell_value if (cell_index==29 and cell_value!='(blank)' and cell_value!='')
              catalog_item_other.total_cost= cell_value if (cell_index==29 and cell_value!='(blank)' and cell_value!='')
              catalog_item_other.save
              catalog_item_extension.other_cost=catalog_item_other.total_cost
              catalog_item_extension.total_cost= (catalog_item_extension.settinglabor_cost || 0 )+(catalog_item_extension.other_cost || 0 )+ (catalog_item_extension.casting_cost || 0) + (catalog_item_extension.finding_cost || 0) + (catalog_item_extension.diamond_cost || 0)
              #              catalog_item_extension.total_cost=(catalog_item_extension.other_cost || 0 )+ (catalog_item_extension.casting_cost || 0) + (catalog_item_extension.diamond_cost || 0)
              catalog_item_extension.save
            when 30..31 #item Price
              catalog_item.cost= cell_value if (cell_index==30 and cell_value!='(blank)' and cell_value!='' and cell_value!=0)
              catalog_item.image_thumnail=catalog_item.image_normal=catalog_item.image_enlarge=catalog_item.image_small=cell_value if cell_index==31
              catalog_item.meta_tag=meta_tag
              catalog_item.save  
             
            else
            end
          }
        end
      } 
      #  rescue ActiveRecord::StatementInvalid 
      puts text
    rescue StandardError=>ex
      puts "An error occurred"
      return 'error'
    end
    return text
  end
end
