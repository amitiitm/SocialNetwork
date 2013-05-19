class Purchase::PurchaseIndentApprovalCrud < Crud
  include General
  require "rexml/document"
  include REXML
  
  def self.list_indent_approvals(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchaseIndentLine.find_by_sql ["select CAST( (select(select purchase_indents.id,purchase_indents.trans_bk,
                                          purchase_indents.trans_no,
                                          purchase_indents.trans_date,
                                          purchase_indents.ship_date,  
                                          purchase_indents.due_date,
                                          purchase_indents.term_code,
                                          purchase_indents.shipping_code,
                                          purchase_indents.account_period_code,
                                          purchase_indent_lines.catalog_item_code,
                                          purchase_indent_lines.item_qty,
                                          purchase_indent_lines.clear_qty,
                                          purchase_indent_lines.id,
                                          purchase_indent_lines.serial_no,
                                          catalog_items.id as catalog_item_id,
                                          catalog_items.item_type as catalog_item_type,
                                          catalog_items.name as catalog_item_name,  
                                          companies.company_cd as company_code,
                                          companies.id as company_id from purchase_indent_lines
                                          inner join companies on companies.id = purchase_indent_lines.company_id 
                                          inner join purchase_indents on purchase_indents.id = purchase_indent_lines.purchase_indent_id
                                          inner join catalog_items on catalog_items.id = purchase_indent_lines.catalog_item_id
                                          where ( (purchase_indent_lines.item_qty - purchase_indent_lines.clear_qty) > 0 ) AND
                                          ( purchase_indent_lines.company_id = #{criteria.company_id}) AND
                                          (companies.company_cd between '#{criteria.str1}' and '#{criteria.str2}' AND (0 = #{criteria.multiselect1.length} or companies.company_cd in ('#{criteria.multiselect1}'))) AND
                                          (purchase_indents.account_period_code between '#{ criteria.str3[0,8]}' and '#{ criteria.str4[0,8]}' AND (0 = #{criteria.multiselect2.length} or purchase_indents.account_period_code in ('#{criteria.multiselect2}'))) AND
                                          (purchase_indents.trans_no between '#{criteria.str5}' and '#{criteria.str6}' AND (0 = #{criteria.multiselect3.length}  or purchase_indents.trans_no in ('#{criteria.multiselect3}'))) AND
                                          (purchase_indent_lines.catalog_item_code between '#{criteria.str7}' and '#{criteria.str8}' AND (0 = #{criteria.multiselect4.length} or purchase_indent_lines.catalog_item_code in ('#{criteria.multiselect4}'))) AND
                                          (purchase_indents.trans_date between '#{criteria.dt1}' and '#{criteria.dt2}')
                                          FOR XML PATH('indent_approval'),type,elements xsinil)FOR XML PATH('indent_approvals')) AS xml) as xmlcol 
      " ]
  end
  
  def self.create_indent_approvals(doc)
    indent_approvals = []
    (doc/:indent_approvals/:indent_approval).each{|transfer_doc|
      indent_approval = create_indent_approval(transfer_doc)
      indent_approvals <<  indent_approval if indent_approval
    }
    #  Inventory::InventoryTransactionCrud.post_receive_transaction(inventory_transfers)
    indent_approvals
  end
  
  def self.create_indent_approval(doc)
    indent_approval = add_or_modify_indent_approval(doc)
    return  if !indent_approval
    save_proc = Proc.new{
      indent_approval.save!
      production_request = post_request_from_approval(indent_approval)
      production_request.save!
    }
    indent_approval.save_master(&save_proc)
    return indent_approval
  end

  def self.add_or_modify_indent_approval(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first
    indent_approval = Purchase::PurchaseIndentLine.find_or_create(id)
    return if !indent_approval
    if !indent_approval.new_record? and indent_approval.update_flag == 'V'
      indent_approval.errors.add('','This transfer is View Only. Cannot update.')
      return indent_approval
    end
    indent_approval.apply_attributes(doc)
    indent_approval.clear_qty = indent_approval.item_qty
    return indent_approval
  end

  def self.post_request_from_approval(indent)
    production_request = Production::ProductionRequest.new
    production_request.company_id = indent.company_id
    production_request.account_period_code = indent.account_period_code
    production_request.trans_bk = indent.trans_bk
    production_request.trans_no = indent.trans_no
    production_request.trans_date = indent.trans_date
    production_request.clear_qty = indent.clear_qty
    production_request.item_qty = indent.item_qty
    production_request.trans_flag = indent.trans_flag
    production_request.catalog_item_id = indent.catalog_item_id
    production_request.catalog_item_code = indent.catalog_item_code
    production_request.ref_trans_bk = indent.trans_bk
    production_request.ref_trans_no = indent.trans_no
    production_request.ref_qty = indent.ref_qty
    production_request.ref_trans_date = indent.trans_date
    production_request.ref_serial_no = indent.serial_no
    production_request.ext_ref_date = indent.trans_date
  
    production_request
  end


  #def self.generate_po_xml(doc1)
  #  puts doc1
  #  doc1.root.name='purchase_orders'
  #  (doc1/:purchase_orders/:production_request).each{|ele|
  #    ele.name = "purchase_order"
  #    ele.at('ref_trans_no').name="ttt"
  #    ele.at('trans_no').name="ref_trans_no"
  #    ele.at('clear_qty').name="xx"
  #    ele.at('ref_trans_bk').name="uuu"
  #    ele.at('trans_bk').name="ref_trans_bk"
  #    ele.at('po_vendor_id').name="vendor_id"
  #    ele.at('id').before do
  #      tag!'purchase_order_lines' do
  #        tag!'purchase_order_line' do
  #          tag!'id', ''
  #          tag!'trans_date', (ele/:trans_date).inner_text
  #          tag!'catalog_item_id', (ele/:catalog_item_id).inner_text
  #          tag!'catalog_item_code', (ele/:catalog_item_code).inner_text
  #          tag!'item_qty', (ele/:item_qty).inner_text
  #        end
  #      end
  #    end
  #
  #  }
  #  puts doc1
  #  doc1
  #end
  
end
