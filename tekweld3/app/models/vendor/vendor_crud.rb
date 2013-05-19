class Vendor::VendorCrud
  include General

  def self.list_vendor_categories(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
    #  Vendor::VendorCategory.find_by_code_name_trans_flag(criteria)
    Vendor::VendorCategory.find(:all,
      :conditions => ["(code between ? and ? AND (0 =? or code in (?) ) ) AND
                                              (name between ? and ? AND (0 =? or name in (?) ) )   
        " ,criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
        criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2]
    )
  end

  def self.show_vendor_category(id)
    Vendor::VendorCategory.find_all_by_id(id)
  end

  def self.create_vendor_categories(category_doc)
    vendor_categories = []
    (category_doc/:vendor_categories/:vendor_category).each{|doc|
      vendor_category = create_vendor_category(doc)
      vendor_categories <<  vendor_category if vendor_category
    }
    vendor_categories
  end

  def self.create_vendor_category(doc)
    vendor_category = add_or_modify_category(doc)
    return  if !vendor_category
    save_proc = Proc.new{
      vendor_category.save! 
    }
    vendor_category.save_master(&save_proc)
    return  vendor_category
  end

  def self.add_or_modify_category(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first
    vendor_category = Vendor::VendorCategory.find_or_create(id)
    return if !vendor_category
    vendor_category.apply_attributes(doc)
    #  Add a block to codes
    # invoice_term_code = Terms.find_by_id(parse_xml(doc/'invoice_term_id') if (doc/'invoice_term_id').first ).code
    # memo_term_code = Terms.find_by_id(parse_xml(doc/'memo_term_id') if (doc/'memo_term_id').first ).code
    return vendor_category
  end

  def self.list_vendors(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    var =  Vendor::Vendor.find_by_sql ["select value from types where type_cd = 'master_access' and subtype_cd = 'vendor'"]
    Vendor::Vendor.find_by_sql ("select CAST( (select(SELECT *
                                                      FROM vendors
                                                      where (vendors.company_id in (select company_id from user_companies where user_id = #{criteria.user_id}) OR ascii('All') = ascii('#{var.first.value}')) AND
                                                      (vendors.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 = #{criteria.multiselect1.length} or vendors.code in ('#{criteria.multiselect1}') ) ) AND
                                                      (vendors.name between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or vendors.name in ('#{criteria.multiselect2}') ) )
                                                      FOR XML PATH('vendor'),type,elements xsinil)
                                                      FOR XML PATH('vendors')) AS xml) as xmlcol ")
  end

  def self.show_vendor(gl_id)
    Vendor::Vendor.find_all_by_id(gl_id)
  end

  def self.create_vendors(gl_doc)
    vendors = []
    (gl_doc/:vendors/:vendor).each{|doc|
      vendor = create_vendor(doc)
      vendors <<  vendor if vendor
    }
    vendors
  end

  def self.create_vendor(doc)
    vendor = add_or_modify(doc)
    return  if !vendor
    vendor.code = generate_vendor_code(doc) if vendor.new_record?
    save_proc = Proc.new{
      vendor.save! 
    }
    vendor.save_master(&save_proc)
    return  vendor
  end

  def self.add_or_modify(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first
    vendor = Vendor::Vendor.find_or_create(id)
    return if !vendor
    vendor.apply_attributes(doc)
    #  Add a block to codes
    # invoice_term_code = Terms.find_by_id(invoice_term_id).code
    # memo_term_code = Terms.find_by_id(memo_term_id).code
    return vendor
  end
  def self.generate_vendor_code(doc)
    company_id = parse_xml(doc/'company_id') if (doc/'company_id').first
    name =  parse_xml(doc/'name') if (doc/'name').first
    last_name = name.split(" ")[1]
    code =  name.split(" ")[1] ? name.split(" ").first.first + last_name.slice(0,1) + last_name.slice(1,1) : name.slice(0,1) + name.slice(1,1) + name.slice(2,1)
    sequence_no = generate_docu_no('VE01','VENDID',company_id)
    account_number = code.upcase + sequence_no if sequence_no
    Setup::Sequence.upd_book_code('VE01','VENDID',sequence_no,company_id)
    return account_number
  end

  def self.generate_docu_no(book_code,docu_typ,company_id)
    begin
      if lno = Setup::Sequence.maximum(:book_lno, :conditions =>[ "book_cd =? and docu_typ = ? and company_id =? and trans_flag = 'A'",book_code, docu_typ,company_id])
        lno =lno.to_i + 1
      end
    rescue ActiveRecord::RecordNotFound
      lno = nil
    end
    lno.to_s
  end

end
