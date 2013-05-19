class Purchase::PurchaseIndentCrud
  include General
 
  def self.list_purchase_indents(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchaseIndent.find_by_sql ["select CAST( (select(select purchase_indents.id,purchase_indents.trans_bk,purchase_indents.trans_no,
                                          purchase_indents.trans_date,purchase_indents.account_period_code,
                                          purchase_indents.shipping_code,purchase_indents.ship_date,purchase_indents.term_code,
                                          purchase_indents.remarks from purchase_indents
                                          where (purchase_indents.trans_flag = 'A') AND ( purchase_indents.company_id = #{criteria.company_id}) AND
                                          (account_period_code between '#{criteria.str1[0,8]}' and '#{criteria.str2[0,8]}' AND (0 = #{criteria.multiselect1.length} or account_period_code in ('#{criteria.multiselect1}'))) AND
                                          (trans_no between '#{ criteria.str3}' and '#{ criteria.str4}' AND (0 = #{criteria.multiselect2.length} or trans_no in ('#{criteria.multiselect2}'))) AND
                                          (trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' )
                                           FOR XML PATH('purchase_indent'),type,elements xsinil)FOR XML PATH('purchase_indents')) AS xml) as xmlcol 
      "    ]
  end
  
  def self.show_purchase_indent(id)
    Purchase::PurchaseIndent.find_all_by_id(id)    
  end
  
  def self.create_purchase_indents(doc)
    purchase_indents = []
    (doc/:purchase_indents/:purchase_indent).each{|purchase_indent_doc|
      purchase_indent = create_purchase_indent(purchase_indent_doc)
      purchase_indents <<  purchase_indent if purchase_indent
    }
    purchase_indents
  end

  def self.create_purchase_indent(doc)
    purchase_indent = add_or_modify(doc) 
    purchase_indent.generate_trans_no('PDOIPR') if purchase_indent.new_record?
    purchase_indent.apply_header_fields_to_lines  
    purchase_indent.apply_line_fields_to_header
    return if !purchase_indent
    save_proc = Proc.new{
      if purchase_indent.new_record?
        purchase_indent.save!  
      else
        purchase_indent.save! 
        purchase_indent.purchase_indent_lines.save_line  
      end
    }
    if(purchase_indent.errors.empty?)
      purchase_indent.save_transaction(&save_proc)
    end
    return purchase_indent
  end

  def self.add_or_modify(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first  
    purchase_indent = Purchase::PurchaseIndent.find_or_create(id) 
    return if !purchase_indent
    if purchase_indent.new_record? and purchase_indent.update_flag == 'V'
      purchase_indent.errors.add('','This Purchase Indent is View Only. Cannot update.') 
      return purchase_indent
    end
    purchase_indent.apply_attributes(doc) 
    purchase_indent.fill_default_header_values() if purchase_indent.new_record? 
    purchase_indent.max_serial_no = purchase_indent.purchase_indent_lines.maximum_serial_no
    purchase_indent.build_lines(doc/:purchase_indent_lines/:purchase_indent_line) 
    return purchase_indent
  end
end
