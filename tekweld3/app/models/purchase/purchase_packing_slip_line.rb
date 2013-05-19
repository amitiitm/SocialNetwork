class Purchase::PurchasePackingSlipLine < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General
  include ClassMethods

  belongs_to :purchase_packing_slip, :class_name => 'Purchase::PurchasePackingSlip'
  belongs_to :company, :class_name => 'Setup::Company'
  #  belongs_to :company_store, :class_name => 'Setup::CompanyStore'
  belongs_to :catalog_item, :class_name => 'Item::CatalogItem'
  has_many :transaction_boms, :class_name => 'TransactionBom::TransactionBom' ,:foreign_key => 'type_id' , :extend=>ExtendAssosiation
  validates_uniqueness_of :serial_no, :scope=>[:trans_no, :trans_bk, :trans_date,:company_id]
  validates_presence_of :catalog_item_id, :message=>'Can not be blank'
  #  validates_existence_of :catalog_item_id, :message=>'not exist'

  validates_numericality_of  :item_qty, :clear_qty, :ref_qty, :item_price, :allow_nil=>false, :default=>0
  validates_numericality_of  :discount_amt, :net_amt, :allow_nil=>false, :default=>0
  validates_numericality_of  :discount_per,:less_than_or_equal_to=>9999.99,:default=>0

  def fill_default_detail_values
    self.item_qty ||= nulltozero(self.item_qty)
    self.clear_qty ||= nulltozero(self.clear_qty)
    self.ref_qty ||= nulltozero(self.ref_qty)
    self.item_price ||= nulltozero(self.item_price)
    self.discount_per ||= nulltozero(self.discount_per)
    self.discount_amt ||= nulltozero(self.discount_amt)
    self.net_amt ||= nulltozero(self.net_amt)
    self.trans_bk = 'PL01'
  end


  def add_line_details(line_doc)
    transaction_bom_id =  parse_xml(line_doc/'transaction_bom_id') if (line_doc/'transaction_bom_id').first
    type_id =  parse_xml(line_doc/'type_id') if (line_doc/'type_id').first
    line = bomlines(transaction_bom_id) || nil    if (transaction_bom_id and type_id)
    line_id = line.id  if (line and transaction_bom_id and transaction_bom_id !='')
    line_lock_version = line.lock_version  if (line and transaction_bom_id and transaction_bom_id !='')
    line.apply_attributes(line_doc) if line
    line.types = 'PackingSlip'   if ( line and line.new_record?)
    line.id = line_id    if (line and transaction_bom_id and transaction_bom_id !='')
    line.lock_version = line_lock_version    if (line and transaction_bom_id and transaction_bom_id !='')
    line.type_id = self.id  if (line and  line.new_record?)
    if line
      line.run_block do
        build_lines(line_doc/:catalog_item_diamonds/:catalog_item_diamond)
        build_lines(line_doc/:catalog_item_castings/:catalog_item_casting)
        build_lines(line_doc/:catalog_item_findings/:catalog_item_finding)
        build_lines(line_doc/:catalog_item_others/:catalog_item_other)
        build_lines(line_doc/:catalog_item_stones/:catalog_item_stone)
      end
    end
  end

  def bomlines(transaction_bom_id)
    if  (transaction_bom_id.empty? or transaction_bom_id.to_i == 0) 
      transaction_boms.build 
    else 
      transaction_boms.to_ary.find { |li| li.id == transaction_bom_id.to_i}   #no need to create bom if bom already exists
    end
  end

  def save_lines
    transaction_boms.save_line
  end

  def add_line_errors_to_header
    add_line_item_errors(transaction_boms)
  end

  def apply_header_fields_to_lines()
    self.transaction_boms.each{ |line|
      line.trans_bk = self.trans_bk
      line.trans_no = self.trans_no
      line.trans_date = self.trans_date
      line.company_id = self.company_id
      line.serial_no = self.serial_no
    }
  end


end
