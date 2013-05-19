class Purchase::PurchaseOrderEmailLib
  include General  
  def self.generate_po_pdf_for_chloeandisabel(purchase_order,schema_name)
    date_format = 'mm/dd/yyyy'
    order_id = purchase_order.id
    company_id = purchase_order.company_id
    company=Setup::Company.find_by_id(company_id)
    company.company_logo_file='blank.jpg' if (!company.company_logo_file || company.company_logo_file=='')
    company.business_card = 'blank.jpg' if (!company.business_card  || company.business_card=='')
    company.save!
    path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','REPORT_PRINT'])
    if path 
      directory =  "#{Dir.getwd}" + path.value + schema_name  
    end
    image_path="D:/projects/retail/images/#{schema_name}/"
    rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'porder'"])
    filename = "new_po_attachment#{Time.now().strftime('%Y%m%d%H%M%S')}"
    absolute_filename = File.join(directory, filename)+ "." + "pdf"
    command = "#{Dir.getwd}/fop/printformatpdf.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{order_id} #{date_format} #{image_path}"      
    result = system command
    if result == true 
      return absolute_filename
    end
  end
end