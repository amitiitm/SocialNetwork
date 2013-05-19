class IO::FileIO
  require "rexml/document"
  include REXML
  #  require "spreadsheet/excel"
  #  include Spreadsheet
  include Connectionschema
  #  require 'roo'
  require 'win32ole'

  def self.save(uploaded_file,schema_name)
    filename =  uploaded_file.original_filename.split(".").first
    extension = uploaded_file.original_filename.split(".").last

    #path = Setup::Type.find_by_type_cd('UPLOAD_FOLDER', :conditions=>{:subtype_cd =>'INBOX'})
    path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','INBOX'])
    directory = "public"
    if path
      directory = "public"+path.value + schema_name#/inbox
    end if

    # create the file path
    filename = filename+Time.now().strftime('%m-%d-%Y-%H%-%M-%S') + "." + extension

    filename = File.join(directory, filename)

    if !File.exists?(File.dirname(filename))
      FileUtils.mkdir_p(File.dirname(filename))
    end
    if uploaded_file.instance_of?(Tempfile)
      FileUtils.copy(uploaded_file.local_path, filename)
    else
      uploaded_file.rewind
      File.open(filename, "wb") { |f| f.write(uploaded_file.read) }
    end
    path(filename)
  end

  def self.move(uploaded_file,uploaded_file_name,code)
    #filename = File.basename(uploaded_file)
    directory = "public"
    if code < 0
      path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','ERROR'])
      if path
        directory = "public"+path.value       #directory = "public/error"
      end
    else
      path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','BACKUP'])
      if path
        directory = "public"+path.value             #directory = "public/backup"
      end
    end
    uploaded_file_name = File.join(directory, uploaded_file_name)
    FileUtils.move(uploaded_file, uploaded_file_name)
  end

  def self.path(file)
    File.expand_path("#{Rails.root}/#{file}")
    #File.expand_path("#{Rails.root}/public/files/#{@filename}")--
  end

  def self.read(filename)
    file = File.open(filename , 'r')
    file.rewind
    filedata = file.read
    file.close
    filedata
  end

  def self.write_to_xml(uploaded_file,errorlog)
    filename = File.basename(uploaded_file)
    filename = filename.split(".").first
    filename = filename+'_log'+ ".XML"
    path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','LOG'])
    directory = "public"
    if path
      directory = "public"+path.value             #    directory = "public/log"
    end
    filename = File.join(directory, filename)
    doc = REXML::Document.new()
    doc.add_element('errors')
    errorlog.each do |element|
      inner = REXML::Element.new('error')
      doc.root.add_element(inner)
      body = REXML::Element.new('field')
      body.text = element[0]
      inner.add_element(body)
      body = REXML::Element.new('err')
      body.text = element[1]
      inner.add_element(body)
    end
    file = File.new(filename,'w')
    file.puts doc
    file.close

    filename
  end

  def self.data_of_excel(uploaded_file)
    application = WIN32OLE.new('Excel.Application')
    application.visible = false
    worksheet=application.Workbooks.Open(uploaded_file.tempfile.path).Worksheets(1)
    worksheet.Activate
    @data_rows=worksheet.UsedRange.value
    application.ActiveWorkbook.Close(0)
    application.quit
    data_rows = []
    @data_rows.each{|row|
      data_row=[]
      row.each{|cell|
        data_row << cell.to_s
      }
      data_rows << data_row
    }
    return data_rows
  end

  def self.save_image(uploaded_file,schema_name)
    filename =  uploaded_file.original_filename.split(".").first
    extension = uploaded_file.original_filename.split(".").last

    #path = Setup::Type.find_by_type_cd('UPLOAD_FOLDER', :conditions=>{:subtype_cd =>'INBOX'})
    path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','IMAGE'])
    path_for_catalog = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','CATALOG_IMAGE'])
    if path
      directory = path.value + schema_name#/inbox
      directory_for_catalog = path_for_catalog.value + schema_name
    end if

    # create the file path
    filename = filename+"." + extension
    filename_for_catalog = filename

    filename = File.join(directory, filename)
    filename_for_catalog = File.join(directory_for_catalog, filename_for_catalog)

    if !File.exists?(File.dirname(filename))
      FileUtils.mkdir_p(File.dirname(filename))
    end
    if !File.exists?(File.dirname(filename_for_catalog))
      FileUtils.mkdir_p(File.dirname(filename_for_catalog))
    end
    if uploaded_file.instance_of?(Tempfile)
      FileUtils.copy(uploaded_file.local_path, filename)
    else
      uploaded_file.rewind
      File.open(filename, "wb") { |f| f.write(uploaded_file.read) }
    end
    if uploaded_file.instance_of?(Tempfile)
      FileUtils.copy(uploaded_file.local_path, filename_for_catalog)
    else
      uploaded_file.rewind
      File.open(filename_for_catalog, "wb") { |f| f.write(uploaded_file.read) }
    end
    filename
    #    schema_name+'/'+filename
  end

  def self.save_catalog_image(uploaded_file,schema_name)
    filename =  uploaded_file.original_filename.split(".").first
    extension = uploaded_file.original_filename.split(".").last

    #path = Setup::Type.find_by_type_cd('UPLOAD_FOLDER', :conditions=>{:subtype_cd =>'INBOX'})
    path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','CATALOG_IMAGE'])
    path_for_retail = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','IMAGE'])

    if path
      directory = path.value + schema_name #/inbox
      directory_for_retail = path_for_retail.value + schema_name  if path_for_retail
    end if

    # create the file path
    filename = filename+"." + extension
    filename_for_retail = filename


    filename = File.join(directory, filename)
    filename_for_retail = File.join(directory_for_retail, filename_for_retail)

    if !File.exists?(File.dirname(filename))
      FileUtils.mkdir_p(File.dirname(filename))
    end

    if !File.exists?(File.dirname(filename_for_retail))
      FileUtils.mkdir_p(File.dirname(filename_for_retail))
    end
    if uploaded_file.instance_of?(Tempfile)
      FileUtils.copy(uploaded_file.local_path, filename)
    else
      uploaded_file.rewind
      File.open(filename, "wb") { |f| f.write(uploaded_file.read) }
    end

    if uploaded_file.instance_of?(Tempfile)
      FileUtils.copy(uploaded_file.local_path, filename_for_retail)
    else
      uploaded_file.rewind
      File.open(filename_for_retail, "wb") { |f| f.write(uploaded_file.read) }
    end
    filename
  end

  def self.save_attachment(uploaded_file,schema_name)
    filename =  uploaded_file.original_filename.split(".").first
    extension = uploaded_file.original_filename.split(".").last

    path = Setup::Type.find_by_type_cd_and_subtype_cd('UPLOAD_FOLDER','ATTACHMENT')
    if path
      directory = path.value + schema_name + '/'
    else
      directory = ""
    end if

    # create the file path
    filename = filename+ "." + extension
    filename = File.join(directory, filename)

    if !File.exists?(File.dirname(filename))
      FileUtils.mkdir_p(File.dirname(filename))
    end
    if uploaded_file.instance_of?(Tempfile)
      FileUtils.copy(uploaded_file.local_path, filename)
    else
      uploaded_file.rewind
      File.open(filename, "wb") { |f| f.write(uploaded_file.read) }
    end
    return path(filename),directory
  end
  ## function which store the item templates in separate folder
  def self.save_item_templates(uploaded_file,schema_name)
    filename =  uploaded_file.original_filename.split(".").first
    extension = uploaded_file.original_filename.split(".").last
    path = Setup::Type.find_by_type_cd_and_subtype_cd('UPLOAD_FOLDER','TEMPLATE_PATH')
    if path
      directory = path.value + schema_name + '/'
    else
      directory = ""
    end if
    # create the file path
    filename = filename+ "." + extension
    filename = File.join(directory, filename)

    if !File.exists?(File.dirname(filename))
      FileUtils.mkdir_p(File.dirname(filename))
    end
    if uploaded_file.instance_of?(Tempfile)
      FileUtils.copy(uploaded_file.local_path, filename)
    else
      uploaded_file.rewind
      File.open(filename, "wb") { |f| f.write(uploaded_file.read) }
    end
    return path(filename),directory
  end

  def self.upload_image(filedata,schema_name)
    file_name = IO::FileIO.save_image(filedata,schema_name)
    msgtext = "succeefully uploaded "+file_name
    msgtext
  end

  def self.import_csv(upload_file_path)
    file = File.open(upload_file_path, "r")
    data_array = []
    data = []
    lines = []
    lines = file.readlines
    lines.each{|record|
      data = record.split(",")
      data_array < data
    }

    return data_array
  end

  def self.write_to_excel(doc,schema_name)
    begin
      filename = Time.now().strftime('%m-%d-%Y-%H%-%M-%S') + "." + "xls"
      path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','REPORT_EXPORT'])
      if path
        directory =  "#{Dir.getwd}" + path.value + schema_name
      end
      absolute_filename = File.join(directory, filename)
      workbook = Excel.new(absolute_filename)
      worksheet = workbook.add_worksheet
      row=0
      cell=0
      (doc/:table/:tr).each do |link|
        cell=0
        (link/:td).each do |cell_data|
          column=cell_data.inner_text
          worksheet.write(row, cell, column)
          cell=cell+1
        end
        row=row+1
      end
      workbook.close
    rescue Errno::ENOENT   # To handle file/folder does not exists exception
      #    Dir.mkdir(directory)
      FileUtils.mkdir_p(directory)
      retry
    end
    msgtext = filename
    msgtext
  end

  def self.read_excel(workbook,extension)
    price_models=[]
    if extension=='xlsx'
      workbook.default_sheet = workbook.sheets.first
      end_row=workbook.last_row
      start_column=workbook.first_column
      last_column=workbook.last_column
      (workbook.first_row).upto(end_row) {|row|
        @price_model = Item::CatalogItemPrice.new
        case row
        when 1
          start_column.upto(last_column){|col|
            cell_value = workbook.cell(row,col).to_s.capitalize if workbook.cell(row,col)
          }
        else
          start_column.upto(last_column){|col|
            cell_value = workbook.cell(row,col).to_s.capitalize if workbook.cell(row,col)
            case col
            when 1 #item code
              catalog_item_code = workbook.cell(row,col).to_s if workbook.cell(row,col) #cell_value
              puts catalog_item_code
              catalog_item = Item::CatalogItem.find_by_store_code(catalog_item_code.upcase)
              puts catalog_item
              @price_model.catalog_item_id = catalog_item.id if catalog_item
              if !catalog_item
                @price_model.status = 'Invalid Item'
                @price_model.update = 'NO'
              else
                @price_model.status = ''
                @price_model.update = 'YES'
              end
            when 2 #item from date
              #            price_model.from_date = cell.to_s('latin1') if cell #cell_value
              @price_model.from_date =cell_value
            when 3 #item to date
              @price_model.to_date= cell_value
            when 4 #item price
              @price_model.price = workbook.cell(row,col).to_s if workbook.cell(row,col) #cell_value
            when 5 #item disc amt
              @price_model.discount_amt = workbook.cell(row,col).to_s if workbook.cell(row,col) #cell_value
            when 6 #item per
              @price_model.discount_per= workbook.cell(row,col).to_s if workbook.cell(row,col) #cell_value
              unless price_models.include?(@price_model)
                price_models << @price_model
              end
            end
          }
        end
      }
    end
    if extension=='xls'
      workbook.worksheet(0).each_with_index {|row,row_index|
        @price_model = Item::CatalogItemPrice.new
        case row_index
        when 0
          row.each_with_index{|cell,cell_index|
            cell_value = cell.to_s('latin1').capitalize if cell ;
          }
        else
          row.each_with_index{|cell,cell_index|
            cell_value = cell.to_s('latin1').capitalize if cell ;
            #          @price_model = Item::CatalogItemPrice.new
            case cell_index
            when 0 #item code
              catalog_item_code = cell.to_s('latin1') if cell #cell_value
              puts catalog_item_code
              catalog_item = Item::CatalogItem.find_by_store_code(catalog_item_code.upcase)
              puts catalog_item
              @price_model.catalog_item_id = catalog_item.id if catalog_item
              if !catalog_item
                @price_model.status = 'Invalid Item'
                @price_model.update = 'NO'

              else
                @price_model.status = ''
                @price_model.update = 'YES'
              end
            when 1 #item from date
              #            price_model.from_date = cell.to_s('latin1') if cell #cell_value
              @price_model.from_date =cell_value
            when 2 #item to date
              @price_model.to_date= cell_value
            when 3 #item price
              @price_model.price = cell.to_s('latin1') if cell #cell_value
            when 4 #item disc amt
              @price_model.discount_amt = cell.to_s('latin1') if cell #cell_value
            when 5 #item per
              @price_model.discount_per= cell.to_s('latin1') if cell #cell_value
              unless price_models.include?(@price_model)
                price_models << @price_model
              end
            end

          }
        end
      }
    end
    return price_models
  end

  def self.upload_blank_image(schema_name)
    source_file = File.open("public/images/blank.jpg",'r')
    filename= 'blank'
    extension = 'jpg'
    path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','IMAGE'])
    if path
      directory = "#{Dir.getwd}" + '/' + path.value + schema_name#/inbox
      directory.gsub!('retail','catalogportal3')
    end
    filename = filename+"." + extension
    filename = File.join(directory, filename)
    if !File.exists?(File.dirname(filename))
      FileUtils.mkdir_p(File.dirname(filename))
    end
    if source_file.instance_of?(File)
      FileUtils.copy(source_file.path, filename)
    else
      source_file.rewind
      File.open(filename, "wb") { |f| f.write(source_file.read) }
    end
    source_file.close()
  end

  #to save .xlsx file temporary in public/temp folder
  def self.save_xslx(upload)
    name =  upload.original_filename
    directory = "public/temp"
    # create the file path
    path = File.join(directory, name)
    if !File.exists?(File.dirname(path))
      FileUtils.mkdir_p(File.dirname(path))
    end
    # write the file
    File.open(path, "wb") { |f| f.write(upload.read) }
  end

  def self.create_report_export(doc,schema_name)
    group=''
    (doc/'table').each do |data|
      group= data.attributes['group'].to_s
    end
    uniq_iden= rand( 10 ** 10).to_s
    xml_file_name="report_format"+uniq_iden+ "." + "xml"
    xl_filename = "report_format"+uniq_iden+ "." + "xls"
    path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','REPORT_EXPORT'])
    if path
      directory =  "#{Dir.getwd}" + path.value + schema_name
    end
    FileUtils.mkdir_p(directory)
    absolute_filename = File.join(directory, xl_filename)
    xml_filename=File.join(directory, xml_file_name)
    f = File.new(xml_filename, "w+")
    f.write(doc)
    f.close
    xl = WIN32OLE.new('Excel.Application')
    xl.Visible = 0
    xl.Workbooks.open(xml_filename)
    row=0
    (doc/:table/'tr').each do |link|
      cell=0
      (link/'td').each do |cell_data|
        if row==3
          align = cell_data.attributes['align'].to_i
          if cell_data.attributes['datatype'].to_s=='N'
            precision = cell_data.attributes['precision'].to_i
            decimal_count=1
            if precision > 0
              num_format='0.'
              while( decimal_count <= precision)
                num_format=num_format+'0'
                decimal_count+=1
              end
            else
              num_format='0'
            end
            xl.Columns(cell+1).Select
            xl.Selection.NumberFormat = num_format
            xl.Selection.HorizontalAlignment = align
          else
            xl.Columns(cell+1).Select
            xl.Selection.HorizontalAlignment = align
          end
        end
        cell+=1
      end
      break if row==3
      row+=1
    end
    xl.Range("G1").Select
    xl.ActiveCell.FormulaR1C1 = path_change(absolute_filename)
    case group
    when 'G0'
      xl.Run("'#{Dir.getwd}/templates/no_group_export.xlsm'!no_group")
    when 'G1'
      xl.Run("'#{Dir.getwd}/templates/group1_export.xlsm'!group1")
    when 'G2'
      xl.Run("'#{Dir.getwd}/templates/group2_export.xlsm'!group2")
    end
    xl.quit
    msgtext=xl_filename
    msgtext
  end


  def self.create_print_format(doc,schema_name)
    group=''
    (doc/'table').each do |data|
      group= data.attributes['group'].to_s
    end
    uniq_iden= rand( 10 ** 10).to_s
    xml_file_name="report_format"+ uniq_iden+ "." + "xml"
    xl_filename = "report_format"+uniq_iden + "." + "xlsx"
    pdf_file_name = "report_format"+ uniq_iden+ "." + "pdf"
    path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','REPORT_PRINT'])
    if path
      directory =  "#{Dir.getwd}" + path.value + schema_name
    end
    FileUtils.mkdir_p(directory)
    absolute_filename = File.join(directory, xl_filename)
    pdf_filename=File.join(directory, pdf_file_name)
    xml_filename=File.join(directory, xml_file_name)
    f = File.new(xml_filename, "w+")
    f.write(doc)
    f.close
    xl = WIN32OLE.new('Excel.Application')
    xl.Visible = 0
    xl.Workbooks.open(xml_filename)
    row=0
    (doc/:table/'tr').each do |link|
      cell=0
      (link/'td').each do |cell_data|
        if row==3
          align = cell_data.attributes['align'].to_i
          if cell_data.attributes['datatype'].to_s=='N'
            precision = cell_data.attributes['precision'].to_i
            decimal_count=1
            if precision > 0
              num_format='0.'
              while( decimal_count <= precision)
                num_format=num_format+'0'
                decimal_count+=1
              end
            else
              num_format='0'
            end
            xl.Columns(cell+1).Select
            xl.Selection.NumberFormat = num_format
            xl.Selection.HorizontalAlignment = align
          else
            xl.Columns(cell+1).Select
            xl.Selection.HorizontalAlignment = align
          end
        end
        cell+=1
      end
      break if row==3
      row+=1
    end
    xl.Range("F1").Select
    xl.ActiveCell.FormulaR1C1 = path_change(pdf_filename)
    xl.Range("G1").Select
    xl.ActiveCell.FormulaR1C1 = path_change(absolute_filename)
    case group
    when 'G0'
      xl.Run("'#{Dir.getwd}/templates/no_group.xlsm'!no_group")
    when 'G1'
      xl.Run("'#{Dir.getwd}/templates/group1.xlsm'!group1")
    when 'G2'
      xl.Run("'#{Dir.getwd}/templates/group2.xlsm'!group2")
    end
    xl.quit
    msgtext=pdf_file_name
    msgtext
  end

  def self.path_change(filename)
    length=filename.length
    count =0
    while(count<length)
      if filename["/"]
        filename["/"]= "\\"
      end
      count+=1
    end
    return filename
  end

end


