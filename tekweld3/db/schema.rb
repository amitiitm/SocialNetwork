# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 151) do

  create_table "account_periods", :force => true do |t|
    t.integer  "company_id",                    :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",     :limit => 1,  :default => "Y"
    t.string   "trans_flag",      :limit => 1,  :default => "A"
    t.integer  "lock_version",                  :default => 0
    t.string   "code",            :limit => 8,                   :null => false
    t.string   "gl",              :limit => 1,  :default => "C", :null => false
    t.string   "ap",              :limit => 1,  :default => "C", :null => false
    t.string   "ar",              :limit => 1,  :default => "C", :null => false
    t.string   "description",     :limit => 50
    t.datetime "from_date"
    t.string   "ar_post_flag",    :limit => 1
    t.string   "ap_post_flag",    :limit => 1
    t.string   "gl_post_flag",    :limit => 1
    t.integer  "account_year_id"
    t.datetime "in_frdt"
    t.datetime "in_todt"
    t.string   "in_post_flag",    :limit => 1
    t.string   "iv",              :limit => 1
    t.datetime "to_date"
  end

  create_table "account_years", :force => true do |t|
    t.integer  "company_id",                 :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,  :default => "Y"
    t.string   "trans_flag",   :limit => 1,  :default => "A"
    t.integer  "lock_version",               :default => 0
    t.string   "year",         :limit => 10,                  :null => false
    t.string   "from_period",  :limit => 8,                   :null => false
    t.string   "to_period",    :limit => 8,                   :null => false
    t.string   "description",  :limit => 50
    t.string   "ar_flag",      :limit => 1
    t.string   "ap_flag",      :limit => 1
    t.string   "gl_flag",      :limit => 1
  end

  create_table "attachments", :force => true do |t|
    t.integer  "company_id",                  :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,   :default => "Y"
    t.string   "trans_flag",   :limit => 1,   :default => "A"
    t.integer  "lock_version",                :default => 0
    t.string   "table_name",   :limit => 30
    t.integer  "trans_id"
    t.integer  "user_id",                                      :null => false
    t.datetime "date_added"
    t.string   "subject",      :limit => 100
    t.string   "notes",        :limit => 500
    t.string   "file_name",    :limit => 500,                  :null => false
    t.string   "folder_name",  :limit => 500,                  :null => false
  end

  create_table "bank_checks", :force => true do |t|
    t.integer  "company_id",                 :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,  :default => "Y"
    t.string   "trans_flag",   :limit => 1,  :default => "A"
    t.integer  "lock_version",               :default => 0
    t.integer  "bank_id"
    t.integer  "check_from"
    t.integer  "check_to"
    t.string   "payment_type", :limit => 25
  end

  create_table "bank_transaction_lines", :force => true do |t|
    t.integer  "company_id",                                                       :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                     :default => 0
    t.string   "trans_bk",            :limit => 4
    t.string   "trans_no",            :limit => 18
    t.datetime "trans_date"
    t.integer  "gl_account_id"
    t.decimal  "debit_amt",                         :precision => 12, :scale => 2
    t.decimal  "credit_amt",                        :precision => 12, :scale => 2
    t.string   "description",         :limit => 50
    t.string   "serial_no",           :limit => 6
    t.integer  "bank_transaction_id"
  end

  add_index "bank_transaction_lines", ["bank_transaction_id"], :name => "idx_bank_transaction_lines_bank_transaction_id"

  create_table "bank_transactions", :force => true do |t|
    t.integer  "company_id",                                                        :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                      :default => 0
    t.string   "trans_bk",            :limit => 4
    t.string   "trans_no",            :limit => 18
    t.datetime "trans_date"
    t.datetime "check_date"
    t.datetime "clear_date"
    t.string   "account_period_code", :limit => 8
    t.string   "post_flag",           :limit => 1
    t.string   "clear_flag",          :limit => 1
    t.string   "action_flag",         :limit => 1
    t.string   "account_flag",        :limit => 1
    t.string   "trans_type",          :limit => 4
    t.string   "payment_type",        :limit => 4
    t.integer  "account_id"
    t.integer  "bank_id"
    t.decimal  "debit_amt",                          :precision => 12, :scale => 2
    t.decimal  "credit_amt",                         :precision => 12, :scale => 2
    t.string   "check_no",            :limit => 15
    t.string   "remarks",             :limit => 50
    t.string   "ref_no",              :limit => 50
    t.string   "payto_name",          :limit => 50
    t.string   "comments",            :limit => 300
    t.string   "serial_no",           :limit => 6
    t.string   "deposit_no",          :limit => 25
  end

  create_table "banks", :force => true do |t|
    t.integer  "company_id",                                                  :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",    :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",     :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                :default => 0
    t.string   "code",           :limit => 25
    t.string   "name",           :limit => 50
    t.string   "address1",       :limit => 50
    t.string   "address2",       :limit => 50
    t.string   "bank_acct_no",   :limit => 30
    t.string   "transit_no",     :limit => 30
    t.string   "contact_nm",     :limit => 30
    t.string   "city",           :limit => 20
    t.string   "country",        :limit => 20
    t.string   "zip",            :limit => 15
    t.string   "state",          :limit => 25
    t.integer  "gl_category_id"
    t.datetime "start_date"
    t.string   "account_type",   :limit => 2
    t.string   "balance_type",   :limit => 2
    t.decimal  "credit_limit",                 :precision => 12, :scale => 2
    t.string   "payment_type",   :limit => 25
  end

  create_table "break_points", :force => true do |t|
    t.integer  "company_id",                                   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",   :limit => 1,  :default => "Y"
    t.string   "trans_flag",    :limit => 1,  :default => "A"
    t.integer  "lock_version",                :default => 0
    t.string   "category_code", :limit => 50
    t.string   "breakpoint1",   :limit => 50
    t.integer  "sold_amt"
    t.integer  "cost"
    t.integer  "total_qty"
    t.integer  "jan"
    t.integer  "feb"
    t.integer  "mar"
    t.integer  "apr"
    t.integer  "may"
    t.integer  "jun"
    t.integer  "jul"
    t.integer  "aug"
    t.integer  "sep"
    t.integer  "oct"
    t.integer  "nov"
    t.integer  "dec"
    t.integer  "sequence"
  end

  create_table "carts", :force => true do |t|
    t.integer  "company_id",                                                     :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",      :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",       :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                   :default => 0
    t.integer  "user_id",                                                        :default => 0
    t.integer  "qty",                                                            :default => 0
    t.decimal  "item_price",                      :precision => 12, :scale => 2
    t.decimal  "amount",                          :precision => 12, :scale => 2
    t.decimal  "discount",                        :precision => 12, :scale => 2
    t.datetime "cart_date"
    t.string   "status",           :limit => 1,                                  :default => "C"
    t.string   "comments",         :limit => 200
    t.integer  "catalog_item_id",                                                                 :null => false
    t.integer  "customer_id",                                                                     :null => false
    t.string   "spo_flag",         :limit => 1,                                  :default => "N"
    t.string   "spo_size",         :limit => 25
    t.string   "spo_head_size",    :limit => 25
    t.string   "spo_metal_type",   :limit => 25
    t.string   "spo_diamond_qlty", :limit => 25
    t.string   "spo_metal_color",  :limit => 25
  end

  create_table "catalog_abouts", :force => true do |t|
    t.integer  "company_id",                   :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,    :default => "Y"
    t.string   "trans_flag",   :limit => 1,    :default => "A"
    t.integer  "lock_version",                 :default => 0
    t.string   "code",         :limit => 25,                    :null => false
    t.string   "name",         :limit => 50
    t.string   "description",  :limit => 1500
    t.string   "image_file",   :limit => 200
    t.integer  "sequence",                     :default => 0
  end

  create_table "catalog_attribute_values", :force => true do |t|
    t.integer  "company_id",                          :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",          :limit => 1,   :default => "Y"
    t.string   "trans_flag",           :limit => 1,   :default => "A"
    t.integer  "lock_version",                        :default => 0
    t.integer  "catalog_attribute_id",                                 :null => false
    t.string   "code",                 :limit => 25,                   :null => false
    t.string   "name",                 :limit => 50,                   :null => false
    t.string   "description",          :limit => 100
  end

  add_index "catalog_attribute_values", ["catalog_attribute_id"], :name => "idx_catalog_attribute_values_catalog_attribute_id"

  create_table "catalog_attributes", :force => true do |t|
    t.integer  "company_id",                  :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,   :default => "Y"
    t.string   "trans_flag",   :limit => 1,   :default => "A"
    t.integer  "lock_version",                :default => 0
    t.string   "code",         :limit => 25,                   :null => false
    t.string   "name",         :limit => 50,                   :null => false
    t.string   "description",  :limit => 100
    t.string   "is_boolean",   :limit => 1,   :default => "N"
  end

  create_table "catalog_customer_service_lines", :force => true do |t|
    t.integer  "company_id",                                         :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",       :limit => 1,    :default => "Y"
    t.string   "trans_flag",        :limit => 1,    :default => "A"
    t.integer  "lock_version",                      :default => 0
    t.string   "main_heading_code", :limit => 25
    t.string   "heading",           :limit => 100
    t.string   "paragraph",         :limit => 3000
    t.string   "link1_text",        :limit => 100
    t.string   "link1_url",         :limit => 100
    t.string   "link2_text",        :limit => 100
    t.string   "link2_url",         :limit => 100
    t.string   "link3_text",        :limit => 100
    t.string   "link3_url",         :limit => 100
    t.integer  "sequence"
    t.string   "diaspark_default",  :limit => 1,    :default => "Y"
  end

  create_table "catalog_customer_services", :force => true do |t|
    t.integer  "company_id",                                        :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",       :limit => 1,   :default => "Y"
    t.string   "trans_flag",        :limit => 1,   :default => "A"
    t.integer  "lock_version",                     :default => 0
    t.string   "section",           :limit => 100
    t.string   "main_heading_code", :limit => 25
    t.string   "main_heading",      :limit => 100
    t.integer  "sequence"
    t.string   "diaspark_default",  :limit => 1,   :default => "Y"
    t.string   "visible_flag",      :limit => 1,   :default => "Y"
  end

  create_table "catalog_group_hierarchies", :force => true do |t|
    t.integer  "company_id",                  :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,   :default => "Y"
    t.string   "trans_flag",   :limit => 1,   :default => "A"
    t.integer  "lock_version",                :default => 0
    t.string   "hierarchy",    :limit => 500, :default => " ", :null => false
  end

  create_table "catalog_group_items", :force => true do |t|
    t.integer  "company_id",                    :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",      :limit => 1, :default => "Y"
    t.string   "trans_flag",       :limit => 1, :default => "A"
    t.integer  "lock_version",                  :default => 0
    t.integer  "catalog_group_id",                               :null => false
    t.integer  "catalog_item_id",                                :null => false
  end

  create_table "catalog_groups", :force => true do |t|
    t.integer  "company_id",                  :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,   :default => "Y"
    t.string   "trans_flag",   :limit => 1,   :default => "A"
    t.integer  "lock_version",                :default => 0
    t.string   "code",         :limit => 25,                   :null => false
    t.string   "name",         :limit => 50,                   :null => false
    t.string   "description",  :limit => 100
  end

  create_table "catalog_inventories", :force => true do |t|
    t.integer  "company_id",                                                                           :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",           :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",            :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                        :default => 0
    t.string   "item_type",             :limit => 1
    t.string   "catalog_item_category", :limit => 250
    t.string   "open_sales_order",      :limit => 18
    t.string   "edii_pending_order",    :limit => 18
    t.decimal  "rts_qty",                              :precision => 10, :scale => 2
    t.decimal  "pl_qty",                               :precision => 10, :scale => 2
    t.string   "catalog_item_id",       :limit => 50
  end

  create_table "catalog_item_attributes_values", :force => true do |t|
    t.integer  "company_id",                              :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",                :limit => 1, :default => "Y"
    t.string   "trans_flag",                 :limit => 1, :default => "A"
    t.integer  "lock_version",                            :default => 0
    t.integer  "catalog_item_id",                                          :null => false
    t.integer  "catalog_attribute_id",                                     :null => false
    t.integer  "catalog_attribute_value_id",                               :null => false
  end

  create_table "catalog_item_castings", :force => true do |t|
    t.integer  "company_id",                                                                       :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",       :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",        :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                    :default => 0
    t.integer  "catalog_item_id",                                                 :default => 0
    t.string   "catalog_item_code", :limit => 25
    t.integer  "serial_no"
    t.string   "setter",            :limit => 1
    t.string   "supplier",          :limit => 1
    t.string   "billed_wt_flag",    :limit => 1,                                  :default => "C"
    t.string   "unit",              :limit => 4
    t.decimal  "qty",                              :precision => 5,  :scale => 1
    t.string   "metal_type",        :limit => 4
    t.string   "metal_color",       :limit => 25
    t.decimal  "metal_size",                       :precision => 7,  :scale => 2
    t.decimal  "total_cost",                       :precision => 10, :scale => 2
    t.string   "vendor_id",         :limit => 18
    t.string   "vendor_item_id",    :limit => 18
    t.string   "cast_cd",           :limit => 18
    t.string   "duty_flag",         :limit => 1
    t.decimal  "markup_per",                       :precision => 12, :scale => 2
    t.decimal  "price",                            :precision => 12, :scale => 2
    t.string   "remarks",           :limit => 250
    t.decimal  "casting_cost",                     :precision => 12, :scale => 2
    t.decimal  "cost",                             :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "labor",                            :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "wt",                               :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "finished_wt",                      :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "total_wt",                         :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "gold_surcharge",                   :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "labor_wt",                         :precision => 12, :scale => 2, :default => 0.0
  end

  create_table "catalog_item_categories", :force => true do |t|
    t.integer  "company_id",                 :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,  :default => "Y"
    t.string   "trans_flag",   :limit => 1,  :default => "A"
    t.integer  "lock_version",               :default => 0
    t.string   "code",         :limit => 25,                  :null => false
    t.string   "name",         :limit => 50
  end

  create_table "catalog_item_category_attributes", :force => true do |t|
    t.integer  "company_id",                            :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1, :default => "Y"
    t.string   "trans_flag",               :limit => 1, :default => "A"
    t.integer  "lock_version",                          :default => 0
    t.integer  "catalog_item_category_id",                               :null => false
    t.integer  "catalog_attribute_id",                                   :null => false
  end

  create_table "catalog_item_cust_parameters", :force => true do |t|
    t.integer  "company_id",                                                                      :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",       :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",        :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                   :default => 0
    t.integer  "catalog_item_id",                                                :default => 0
    t.string   "catalog_item_code", :limit => 25
    t.integer  "serial_no"
    t.integer  "customer_id",                                                                     :null => false
    t.string   "customer_sku_no",   :limit => 25
    t.decimal  "price",                           :precision => 10, :scale => 2, :default => 1.0
  end

  create_table "catalog_item_diamonds", :force => true do |t|
    t.integer  "company_id",                                                                       :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",       :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",        :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                    :default => 0
    t.integer  "catalog_item_id",                                                 :default => 0
    t.string   "catalog_item_code", :limit => 25
    t.integer  "serial_no"
    t.string   "shade",             :limit => 4
    t.string   "cut",               :limit => 4
    t.string   "stone_type",        :limit => 4
    t.string   "stone_quality",     :limit => 25
    t.string   "stone_setting",     :limit => 4
    t.string   "stone_shape",       :limit => 25
    t.string   "stone_size",        :limit => 25
    t.decimal  "sieve_size",                       :precision => 8,  :scale => 4
    t.string   "color_from",        :limit => 25
    t.string   "color_to",          :limit => 25
    t.string   "clarity_from",      :limit => 25
    t.string   "clarity_to",        :limit => 25
    t.string   "sizemm_from",       :limit => 25
    t.string   "sizemm_to",         :limit => 25
    t.string   "from_width",        :limit => 25
    t.string   "to_width",          :limit => 25
    t.string   "stone_sizegroup",   :limit => 20
    t.decimal  "stone_loss_amt",                   :precision => 12, :scale => 2
    t.decimal  "qty",                              :precision => 5,  :scale => 1
    t.decimal  "wt",                               :precision => 8,  :scale => 4
    t.decimal  "total_wt",                         :precision => 10, :scale => 4
    t.decimal  "cost",                             :precision => 10, :scale => 2
    t.decimal  "price_per_pcs",                    :precision => 10, :scale => 2
    t.decimal  "total_cost",                       :precision => 10, :scale => 2
    t.decimal  "labor",                            :precision => 8,  :scale => 2
    t.decimal  "setting_cost",                     :precision => 10, :scale => 2
    t.decimal  "cert_cost",                        :precision => 10, :scale => 2
    t.string   "make",              :limit => 4
    t.string   "setter",            :limit => 1
    t.string   "supplier",          :limit => 1
    t.string   "duty_flag",         :limit => 1
    t.string   "cert_flag",         :limit => 1
    t.string   "cert_lab_code",     :limit => 18
    t.string   "flag1",             :limit => 1
    t.string   "remarks",           :limit => 250
    t.decimal  "markup_per",                       :precision => 12, :scale => 2
    t.decimal  "price",                            :precision => 12, :scale => 2
  end

  create_table "catalog_item_extensions", :force => true do |t|
    t.integer  "company_id",                                                                               :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",               :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",                :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                            :default => 0
    t.integer  "catalog_item_id",                                                         :default => 0
    t.decimal  "wt",                                       :precision => 10, :scale => 4
    t.decimal  "min_wt",                                   :precision => 10, :scale => 4
    t.decimal  "max_wt",                                   :precision => 10, :scale => 4
    t.string   "mm_size",                   :limit => 25
    t.decimal  "style_cost",                               :precision => 10, :scale => 2
    t.decimal  "silver_base_rate",                         :precision => 12, :scale => 2
    t.decimal  "silver_surcharge",                         :precision => 12, :scale => 2
    t.decimal  "silver_total_rate",                        :precision => 12, :scale => 2
    t.decimal  "silver_mu",                                :precision => 12, :scale => 2
    t.decimal  "gold_base_rate",                           :precision => 12, :scale => 2
    t.decimal  "gold_surcharge",                           :precision => 12, :scale => 2
    t.decimal  "gold_total_rate",                          :precision => 12, :scale => 2
    t.decimal  "gold_mu",                                  :precision => 12, :scale => 2
    t.decimal  "gold_increment",                           :precision => 8,  :scale => 6
    t.decimal  "platinum_base_rate",                       :precision => 12, :scale => 2
    t.decimal  "platinum_surcharge",                       :precision => 12, :scale => 2
    t.decimal  "platinum_total_rate",                      :precision => 12, :scale => 2
    t.decimal  "platinum_mu",                              :precision => 12, :scale => 2
    t.string   "diamond_qlty",              :limit => 25
    t.integer  "diamond_qty"
    t.decimal  "diamond_wt",                               :precision => 10, :scale => 4
    t.decimal  "diamond_cost",                             :precision => 10, :scale => 2
    t.decimal  "diamond_mu",                               :precision => 5,  :scale => 2
    t.decimal  "diamond_amt",                              :precision => 10, :scale => 2
    t.decimal  "diamond_mu_retail",                        :precision => 7,  :scale => 2
    t.decimal  "diamond_amt_retail",                       :precision => 10, :scale => 2
    t.string   "color_stone_type",          :limit => 25
    t.string   "color_stone_shape",         :limit => 25
    t.string   "color_stone_size",          :limit => 25
    t.string   "color_stone_qlty",          :limit => 25
    t.integer  "color_stone_qty"
    t.decimal  "color_stone_wt",                           :precision => 10, :scale => 4
    t.decimal  "color_stone_cost",                         :precision => 7,  :scale => 2
    t.decimal  "color_stone_mu",                           :precision => 5,  :scale => 2
    t.decimal  "color_stone_amt",                          :precision => 10, :scale => 2
    t.string   "center_stone_size",         :limit => 25
    t.string   "center_stone_type",         :limit => 25
    t.string   "center_stone_shape",        :limit => 25
    t.string   "center_stone_qlty",         :limit => 25
    t.decimal  "center_stone_cost",                        :precision => 10, :scale => 2
    t.decimal  "center_stone_mu",                          :precision => 7,  :scale => 2
    t.decimal  "center_stone_amt",                         :precision => 10, :scale => 2
    t.decimal  "finishing_labor_cost",                     :precision => 10, :scale => 2
    t.decimal  "finishing_labor_mu",                       :precision => 5,  :scale => 2
    t.decimal  "finishing_labor_amt",                      :precision => 10, :scale => 2
    t.decimal  "finishinglabor_mu_retail",                 :precision => 7,  :scale => 2
    t.decimal  "finishinglabor_amt_retail",                :precision => 10, :scale => 2
    t.decimal  "settinglabor_cost",                        :precision => 10, :scale => 2
    t.decimal  "settinglabor_mu",                          :precision => 5,  :scale => 2
    t.decimal  "settinglabor_amt",                         :precision => 10, :scale => 2
    t.string   "setter_instrucion",         :limit => 100
    t.decimal  "settinglabor_mu_retail",                   :precision => 7,  :scale => 2
    t.decimal  "settinglabor_amt_retail",                  :precision => 10, :scale => 2
    t.decimal  "other_cost",                               :precision => 10, :scale => 2
    t.decimal  "other_mu",                                 :precision => 7,  :scale => 2
    t.decimal  "other_amt",                                :precision => 10, :scale => 2
    t.decimal  "other_mu_retail",                          :precision => 7,  :scale => 2
    t.decimal  "other_amt_retail",                         :precision => 10, :scale => 2
    t.decimal  "total_cost",                               :precision => 10, :scale => 2
    t.decimal  "markup_per",                               :precision => 5,  :scale => 2
    t.decimal  "price",                                    :precision => 10, :scale => 2
    t.string   "mu_margin_flag",            :limit => 1
    t.string   "certificate",               :limit => 1,                                  :default => "N"
    t.decimal  "surcharge_per",                            :precision => 12, :scale => 2
    t.decimal  "surcharge_amt",                            :precision => 12, :scale => 2
    t.decimal  "discount_per",                             :precision => 12, :scale => 2
    t.decimal  "discount_amt",                             :precision => 12, :scale => 2
    t.decimal  "duty_per",                                 :precision => 6,  :scale => 2
    t.decimal  "duty_amt",                                 :precision => 12, :scale => 2
    t.decimal  "markup_per_retail",                        :precision => 7,  :scale => 2
    t.decimal  "retail_price",                             :precision => 12, :scale => 2
    t.string   "casting_color",             :limit => 25
    t.decimal  "casting_size",                             :precision => 7,  :scale => 2
    t.string   "casting_type",              :limit => 25
    t.decimal  "casting_rate",                             :precision => 7,  :scale => 2
    t.decimal  "casting_wt",                               :precision => 10, :scale => 2
    t.string   "casting_unit",              :limit => 25
    t.decimal  "casting_cost",                             :precision => 10, :scale => 2
    t.decimal  "casting_mu",                               :precision => 5,  :scale => 2
    t.decimal  "casting_amt",                              :precision => 10, :scale => 2
    t.decimal  "casting_mu_retail",                        :precision => 7,  :scale => 2
    t.decimal  "casting_amt_retail",                       :precision => 10, :scale => 2
    t.string   "finding_color",             :limit => 25
    t.decimal  "finding_size",                             :precision => 7,  :scale => 2
    t.string   "finding_type",              :limit => 25
    t.decimal  "finding_rate",                             :precision => 7,  :scale => 2
    t.decimal  "finding_wt",                               :precision => 10, :scale => 2
    t.string   "finding_unit",              :limit => 25
    t.decimal  "finding_cost",                             :precision => 10, :scale => 2
    t.decimal  "finding_mu",                               :precision => 5,  :scale => 2
    t.decimal  "finding_amt",                              :precision => 10, :scale => 2
    t.decimal  "finding_mu_retail",                        :precision => 7,  :scale => 2
    t.decimal  "finding_amt_retail",                       :precision => 10, :scale => 2
    t.decimal  "vendor_fixed_cost",                        :precision => 10, :scale => 2
    t.decimal  "color_stone_mu_retail",                    :precision => 12, :scale => 2
    t.decimal  "color_stone_amt_retail",                   :precision => 12, :scale => 2
    t.decimal  "center_stone_retail_mu",                   :precision => 12, :scale => 2
    t.decimal  "center_stone_retail_price",                :precision => 12, :scale => 2
    t.decimal  "center_stone_wt",                          :precision => 12, :scale => 4
    t.decimal  "subtotal_cost",                            :precision => 12, :scale => 2
    t.decimal  "vendor_po_cost",                           :precision => 12, :scale => 2
    t.decimal  "palladium_base_rate",                      :precision => 12, :scale => 2
    t.decimal  "palladium_surcharge",                      :precision => 12, :scale => 2
    t.decimal  "palladium_total_rate",                     :precision => 12, :scale => 2
    t.decimal  "palladium_mu",                             :precision => 12, :scale => 2
  end

  create_table "catalog_item_findings", :force => true do |t|
    t.integer  "company_id",                                                                       :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",       :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",        :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                    :default => 0
    t.integer  "catalog_item_id",                                                 :default => 0
    t.string   "catalog_item_code", :limit => 25
    t.integer  "serial_no"
    t.string   "setter",            :limit => 1
    t.string   "supplier",          :limit => 1
    t.string   "billed_wt_flag",    :limit => 1,                                  :default => "C"
    t.string   "unit",              :limit => 4
    t.decimal  "qty",                              :precision => 5,  :scale => 1
    t.string   "metal_type",        :limit => 4
    t.string   "metal_color",       :limit => 25
    t.decimal  "metal_size",                       :precision => 7,  :scale => 2
    t.decimal  "total_cost",                       :precision => 10, :scale => 2
    t.string   "vendor_id",         :limit => 18
    t.string   "vendor_item_id",    :limit => 18
    t.string   "cast_cd",           :limit => 18
    t.string   "duty_flag",         :limit => 1
    t.decimal  "markup_per",                       :precision => 12, :scale => 2
    t.decimal  "price",                            :precision => 12, :scale => 2
    t.string   "remarks",           :limit => 250
    t.string   "price_flag",        :limit => 1
    t.decimal  "finding_cost",                     :precision => 12, :scale => 2
    t.decimal  "cost",                             :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "labor",                            :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "wt",                               :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "finished_wt",                      :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "total_wt",                         :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "gold_surcharge",                   :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "labor_wt",                         :precision => 12, :scale => 2, :default => 0.0
  end

  create_table "catalog_item_images", :force => true do |t|
    t.integer  "company_id",                                        :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",       :limit => 1,   :default => "Y"
    t.string   "trans_flag",        :limit => 1,   :default => "A"
    t.integer  "lock_version",                     :default => 0
    t.string   "serial_no",         :limit => 6
    t.integer  "catalog_item_id"
    t.string   "catalog_item_code", :limit => 25
    t.string   "image_thumnail"
    t.string   "image_small"
    t.string   "image_normal"
    t.string   "image_enlarge"
    t.string   "image_1200",        :limit => 100
  end

  create_table "catalog_item_lines", :force => true do |t|
    t.integer  "company_id",                                                   :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",      :limit => 1,                                :default => "Y"
    t.string   "trans_flag",       :limit => 1,                                :default => "A"
    t.integer  "lock_version",                                                 :default => 0
    t.integer  "catalog_item_id",                                                               :null => false
    t.string   "serial_no",        :limit => 6
    t.integer  "assemble_item_id",                                                              :null => false
    t.decimal  "qty",                           :precision => 10, :scale => 2
    t.decimal  "cost",                          :precision => 12, :scale => 2
  end

  add_index "catalog_item_lines", ["catalog_item_id"], :name => "idx_catalog_item_lines_catalog_item_id"

  create_table "catalog_item_others", :force => true do |t|
    t.integer  "company_id",                                                                      :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",       :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",        :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                   :default => 0
    t.integer  "catalog_item_id",                                                :default => 0
    t.string   "catalog_item_code", :limit => 25
    t.integer  "serial_no"
    t.string   "other_type",        :limit => 4
    t.string   "other_code",        :limit => 25,                                                 :null => false
    t.string   "supplier",          :limit => 1
    t.string   "setter",            :limit => 1
    t.string   "duty_flag",         :limit => 1,                                 :default => "Y"
    t.decimal  "cost",                            :precision => 10, :scale => 2
    t.decimal  "qty",                             :precision => 10, :scale => 2
    t.decimal  "total_cost",                      :precision => 12, :scale => 2
    t.string   "remarks"
    t.decimal  "price",                           :precision => 12, :scale => 2
  end

  create_table "catalog_item_packages", :force => true do |t|
    t.integer  "company_id",                                                                    :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",     :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",      :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                 :default => 0
    t.integer  "catalog_item_id"
    t.string   "carton_size",     :limit => 50
    t.decimal  "pcs_per_carton",                :precision => 12, :scale => 2
    t.decimal  "carton_wt",                     :precision => 12, :scale => 4, :default => 0.0
  end

  create_table "catalog_item_packet_diamonds", :force => true do |t|
    t.integer  "company_id",                                                                              :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                           :default => 0
    t.integer  "catalog_item_packet_id",                                                 :default => 0
    t.string   "catalog_item_packet_code", :limit => 25
    t.integer  "serial_no"
    t.string   "shade",                    :limit => 4
    t.string   "cut",                      :limit => 4
    t.string   "stone_type",               :limit => 4
    t.string   "stone_quality",            :limit => 25
    t.string   "stone_setting",            :limit => 4
    t.string   "stone_shape",              :limit => 25
    t.string   "stone_size",               :limit => 25
    t.decimal  "sieve_size",                              :precision => 8,  :scale => 4
    t.string   "stone_color",              :limit => 25
    t.string   "stone_clarity",            :limit => 25
    t.string   "stone_sizemm",             :limit => 25
    t.string   "stone_width",              :limit => 25
    t.string   "stone_sizegroup",          :limit => 20
    t.decimal  "stone_loss_amt",                          :precision => 12, :scale => 2
    t.decimal  "qty",                                     :precision => 5,  :scale => 1
    t.decimal  "wt",                                      :precision => 8,  :scale => 4
    t.decimal  "total_wt",                                :precision => 10, :scale => 4
    t.decimal  "cost",                                    :precision => 10, :scale => 2
    t.decimal  "price_per_pcs",                           :precision => 10, :scale => 2
    t.decimal  "total_cost",                              :precision => 10, :scale => 2
    t.decimal  "labor",                                   :precision => 8,  :scale => 2
    t.decimal  "setting_cost",                            :precision => 10, :scale => 2
    t.decimal  "cert_cost",                               :precision => 10, :scale => 2
    t.string   "make",                     :limit => 4
    t.string   "setter",                   :limit => 1
    t.string   "supplier",                 :limit => 1
    t.string   "cert_flag",                :limit => 1
    t.string   "cert_lab_code",            :limit => 18
    t.string   "flag1",                    :limit => 1
    t.decimal  "markup_per",                              :precision => 12, :scale => 2
    t.decimal  "price",                                   :precision => 12, :scale => 2
    t.string   "remarks",                  :limit => 250
  end

  create_table "catalog_item_packet_extensions", :force => true do |t|
    t.integer  "company_id",                                                                           :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",            :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",             :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                        :default => 0
    t.integer  "catalog_item_packet_id",                                              :default => 0
    t.string   "metal_type",             :limit => 25
    t.string   "metal_color",            :limit => 25
    t.decimal  "total_diamond_amt",                    :precision => 12, :scale => 2
    t.decimal  "metal_base_rate",                      :precision => 12, :scale => 2
    t.decimal  "metal_surcharge",                      :precision => 12, :scale => 2
    t.decimal  "metal_total_rate",                     :precision => 12, :scale => 2
    t.decimal  "metal_increment",                      :precision => 8,  :scale => 6
    t.string   "casting_unit",           :limit => 25
    t.decimal  "casting_wt",                           :precision => 10, :scale => 4
    t.decimal  "casting_cost",                         :precision => 12, :scale => 2
    t.decimal  "casting_amt",                          :precision => 12, :scale => 2
    t.string   "finding_unit",           :limit => 25
    t.decimal  "finding_wt",                           :precision => 10, :scale => 4
    t.decimal  "finding_cost",                         :precision => 12, :scale => 2
    t.decimal  "finding_amt",                          :precision => 12, :scale => 2
    t.decimal  "setting_amt",                          :precision => 12, :scale => 2
    t.decimal  "handling_amt",                         :precision => 12, :scale => 2
    t.decimal  "labor_amt",                            :precision => 12, :scale => 2
    t.decimal  "tag_price",                            :precision => 12, :scale => 2
    t.integer  "diamond_qty",                                                         :default => 0
    t.decimal  "diamond_wt",                           :precision => 10, :scale => 4
    t.integer  "color_stone_qty",                                                     :default => 0
    t.decimal  "color_stone_wt",                       :precision => 10, :scale => 4
    t.string   "certificate",            :limit => 1,                                 :default => "N"
  end

  create_table "catalog_item_packet_stones", :force => true do |t|
    t.integer  "company_id",                                                                              :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                           :default => 0
    t.integer  "catalog_item_packet_id",                                                 :default => 0
    t.string   "catalog_item_packet_code", :limit => 25
    t.integer  "serial_no"
    t.string   "shade",                    :limit => 4
    t.string   "cut",                      :limit => 4
    t.string   "stone_type",               :limit => 4
    t.string   "stone_quality",            :limit => 25
    t.string   "stone_setting",            :limit => 4
    t.string   "stone_shape",              :limit => 25
    t.string   "stone_size",               :limit => 25
    t.decimal  "sieve_size",                              :precision => 8,  :scale => 4
    t.string   "stone_color",              :limit => 25
    t.string   "stone_clarity",            :limit => 25
    t.string   "stone_sizemm",             :limit => 25
    t.string   "stone_width",              :limit => 25
    t.string   "stone_sizegroup",          :limit => 20
    t.decimal  "stone_loss_amt",                          :precision => 12, :scale => 2
    t.decimal  "qty",                                     :precision => 5,  :scale => 1
    t.decimal  "wt",                                      :precision => 8,  :scale => 4
    t.decimal  "total_wt",                                :precision => 10, :scale => 4
    t.decimal  "cost",                                    :precision => 10, :scale => 2
    t.decimal  "price_per_pcs",                           :precision => 10, :scale => 2
    t.decimal  "total_cost",                              :precision => 10, :scale => 2
    t.decimal  "labor",                                   :precision => 8,  :scale => 2
    t.decimal  "setting_cost",                            :precision => 10, :scale => 2
    t.decimal  "cert_cost",                               :precision => 10, :scale => 2
    t.string   "make",                     :limit => 4
    t.string   "setter",                   :limit => 1
    t.string   "supplier",                 :limit => 1
    t.string   "cert_flag",                :limit => 1
    t.string   "cert_lab_code",            :limit => 18
    t.string   "flag1",                    :limit => 1
    t.decimal  "markup_per",                              :precision => 12, :scale => 2
    t.decimal  "price",                                   :precision => 12, :scale => 2
    t.string   "remarks",                  :limit => 250
  end

  create_table "catalog_item_packet_update_lines", :force => true do |t|
    t.integer  "company_id",                                                    :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",                   :limit => 1,   :default => "Y"
    t.string   "trans_flag",                    :limit => 1,   :default => "A"
    t.integer  "lock_version",                                 :default => 0
    t.string   "trans_bk",                      :limit => 4,                    :null => false
    t.string   "trans_no",                      :limit => 18,                   :null => false
    t.datetime "trans_date",                                                    :null => false
    t.string   "serial_no",                     :limit => 6
    t.integer  "catalog_item_id",                                               :null => false
    t.string   "code",                          :limit => 25,                   :null => false
    t.string   "description",                   :limit => 100,                  :null => false
    t.string   "attribute1",                    :limit => 50
    t.string   "attribute2",                    :limit => 50
    t.string   "attribute3",                    :limit => 50
    t.string   "attribute4",                    :limit => 50
    t.string   "attribute5",                    :limit => 50
    t.string   "attribute6",                    :limit => 50
    t.string   "attribute7",                    :limit => 50
    t.string   "attribute8",                    :limit => 50
    t.string   "attribute9",                    :limit => 50
    t.string   "attribute10",                   :limit => 50
    t.integer  "catalog_item_packet_update_id"
    t.integer  "catalog_item_packet_id",                                        :null => false
  end

  add_index "catalog_item_packet_update_lines", ["catalog_item_packet_update_id"], :name => "idx_catalog_item_packet_update_lines_catalog_item_packet_update_id"

  create_table "catalog_item_packet_updates", :force => true do |t|
    t.integer  "company_id",                                          :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,   :default => "Y"
    t.string   "trans_flag",          :limit => 1,   :default => "A"
    t.integer  "lock_version",                       :default => 0
    t.string   "trans_bk",            :limit => 4,                    :null => false
    t.string   "ref_trans_bk",        :limit => 4
    t.string   "trans_no",            :limit => 18,                   :null => false
    t.string   "ref_trans_no",        :limit => 18
    t.datetime "trans_date",                                          :null => false
    t.string   "file_name",           :limit => 100
    t.string   "remarks",             :limit => 200
    t.string   "account_period_code", :limit => 25
  end

  create_table "catalog_item_packets", :force => true do |t|
    t.integer  "company_id",                                                                     :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",     :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",      :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                  :default => 0
    t.integer  "catalog_item_id",                                                                :null => false
    t.string   "code",            :limit => 25,                                                  :null => false
    t.string   "attribute1",      :limit => 50
    t.string   "attribute2",      :limit => 50
    t.string   "attribute3",      :limit => 50
    t.string   "attribute4",      :limit => 50
    t.string   "attribute5",      :limit => 50
    t.string   "attribute6",      :limit => 50
    t.string   "attribute7",      :limit => 50
    t.string   "attribute8",      :limit => 50
    t.string   "attribute9",      :limit => 50
    t.string   "attribute10",     :limit => 50
    t.decimal  "price",                          :precision => 12, :scale => 2, :default => 0.0
    t.string   "description",     :limit => 100
    t.string   "tag_line1",       :limit => 100
    t.string   "tag_line2",       :limit => 100
    t.string   "tag_line3",       :limit => 100
    t.string   "tag_line4",       :limit => 100
    t.string   "tag_line5",       :limit => 100
    t.string   "tag_line6",       :limit => 100
    t.string   "tag_line7",       :limit => 100
    t.string   "tag_line8",       :limit => 100
  end

  add_index "catalog_item_packets", ["catalog_item_id"], :name => "catalog_item_packets_catalog_item_id"

  create_table "catalog_item_prices", :force => true do |t|
    t.integer  "company_id",                                                  :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",     :limit => 1,                                :default => "Y"
    t.string   "trans_flag",      :limit => 1,                                :default => "A"
    t.integer  "lock_version",                                                :default => 0
    t.integer  "catalog_item_id",                                             :default => 0
    t.datetime "from_date",                                                                    :null => false
    t.datetime "to_date",                                                                      :null => false
    t.decimal  "price",                        :precision => 12, :scale => 2
    t.decimal  "discount_amt",                 :precision => 12, :scale => 2
    t.decimal  "discount_per",                 :precision => 5,  :scale => 2
    t.string   "price_level",     :limit => 1
  end

  add_index "catalog_item_prices", ["catalog_item_id"], :name => "catalog_item_prices_catalog_item_id"

  create_table "catalog_item_setups", :force => true do |t|
    t.integer  "company_id",                                                                               :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",                :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",                 :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                            :default => 0
    t.integer  "catalog_item_id"
    t.integer  "catalog_setup_item_id"
    t.string   "catalog_setup_item_code",    :limit => 25
    t.string   "catalog_setup_item_charges", :limit => 50
    t.decimal  "amount",                                   :precision => 12, :scale => 2
  end

  create_table "catalog_item_similar_items", :force => true do |t|
    t.integer  "company_id",                                       :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",       :limit => 1,  :default => "Y"
    t.string   "trans_flag",        :limit => 1,  :default => "A"
    t.integer  "lock_version",                    :default => 0
    t.integer  "catalog_item_id",                                  :null => false
    t.string   "serial_no",         :limit => 6
    t.integer  "similar_item_id",                                  :null => false
    t.string   "similar_item_code", :limit => 25
  end

  create_table "catalog_item_stones", :force => true do |t|
    t.integer  "company_id",                                                                       :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",       :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",        :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                    :default => 0
    t.integer  "catalog_item_id",                                                 :default => 0
    t.string   "catalog_item_code", :limit => 25
    t.integer  "serial_no"
    t.string   "shade",             :limit => 4
    t.string   "cut",               :limit => 4
    t.string   "stone_type",        :limit => 4
    t.string   "stone_quality",     :limit => 25
    t.string   "stone_setting",     :limit => 4
    t.string   "stone_shape",       :limit => 25
    t.string   "stone_size",        :limit => 25
    t.decimal  "sieve_size",                       :precision => 8,  :scale => 4
    t.string   "color_from",        :limit => 25
    t.string   "color_to",          :limit => 25
    t.string   "clarity_from",      :limit => 25
    t.string   "clarity_to",        :limit => 25
    t.string   "sizemm_from",       :limit => 25
    t.string   "sizemm_to",         :limit => 25
    t.string   "from_width",        :limit => 25
    t.string   "to_width",          :limit => 25
    t.string   "stone_sizegroup",   :limit => 20
    t.decimal  "stone_loss_amt",                   :precision => 12, :scale => 2
    t.decimal  "qty",                              :precision => 5,  :scale => 1
    t.decimal  "wt",                               :precision => 8,  :scale => 4
    t.decimal  "total_wt",                         :precision => 10, :scale => 4
    t.decimal  "cost",                             :precision => 10, :scale => 2
    t.decimal  "price_per_pcs",                    :precision => 10, :scale => 2
    t.decimal  "total_cost",                       :precision => 10, :scale => 2
    t.decimal  "labor",                            :precision => 8,  :scale => 2
    t.decimal  "setting_cost",                     :precision => 10, :scale => 2
    t.decimal  "cert_cost",                        :precision => 10, :scale => 2
    t.string   "make",              :limit => 4
    t.string   "setter",            :limit => 1
    t.string   "supplier",          :limit => 1
    t.string   "duty_flag",         :limit => 1
    t.string   "cert_flag",         :limit => 1
    t.string   "cert_lab_code",     :limit => 18
    t.string   "flag1",             :limit => 1
    t.string   "remarks",           :limit => 250
    t.decimal  "markup_per",                       :precision => 12, :scale => 2
    t.decimal  "price",                            :precision => 12, :scale => 2
  end

  create_table "catalog_item_vend_parameters", :force => true do |t|
    t.integer  "company_id",                                                                      :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",       :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",        :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                   :default => 0
    t.integer  "catalog_item_id",                                                :default => 0
    t.string   "catalog_item_code", :limit => 25
    t.integer  "serial_no"
    t.integer  "vendor_id",                                                                       :null => false
    t.string   "vendor_sku_no",     :limit => 25
    t.decimal  "price",                           :precision => 10, :scale => 2, :default => 1.0
  end

  create_table "catalog_items", :force => true do |t|
    t.integer  "company_id",                                                              :default => 1
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                   :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                   :default => "A"
    t.integer  "lock_version",                                                            :default => 0
    t.string   "store_code",               :limit => 25,                                                   :null => false
    t.string   "web_code",                 :limit => 25,                                                   :null => false
    t.string   "name",                     :limit => 50
    t.string   "purchase_description",     :limit => 1000
    t.string   "image_thumnail",           :limit => 100
    t.string   "image_small",              :limit => 100
    t.string   "image_normal",             :limit => 100
    t.string   "image_enlarge",            :limit => 100
    t.integer  "reorder_qty",                              :precision => 7,  :scale => 0
    t.integer  "reorder_level",                            :precision => 5,  :scale => 0
    t.decimal  "min_qty",                                  :precision => 12, :scale => 2
    t.decimal  "max_qty",                                  :precision => 12, :scale => 2
    t.datetime "item_date"
    t.integer  "priority",                                                                :default => 0
    t.integer  "catalog_item_category_id"
    t.string   "item_type",                :limit => 1,                                   :default => "I", :null => false
    t.string   "sale_description",         :limit => 1000
    t.string   "barcode",                  :limit => 25
    t.decimal  "cost",                                     :precision => 12, :scale => 2
    t.string   "unit",                     :limit => 10
    t.string   "taxable",                  :limit => 1,                                   :default => "Y", :null => false
    t.integer  "prefered_vendor_id"
    t.string   "vendor_item_name",         :limit => 50
    t.string   "packet_require_yn",        :limit => 1,                                   :default => "N"
    t.string   "meta_tag",                 :limit => 500
    t.string   "sketch_image1",            :limit => 100
    t.string   "sketch_image2",            :limit => 100
    t.string   "sketch_image3",            :limit => 100
    t.string   "image_print",              :limit => 100
    t.string   "tag_line1",                :limit => 100
    t.string   "tag_line2",                :limit => 100
    t.string   "tag_line3",                :limit => 100
    t.string   "tag_line4",                :limit => 100
    t.string   "tag_line5",                :limit => 100
    t.string   "tag_line6",                :limit => 100
    t.string   "tag_line7",                :limit => 100
    t.string   "tag_line8",                :limit => 100
    t.string   "image_1200",               :limit => 100
  end

  add_index "catalog_items", ["store_code"], :name => "catalog_items_store_code"

  create_table "catalog_open_memos", :force => true do |t|
    t.integer  "company_id",                                                                              :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                           :default => 0
    t.string   "trans_bk",                 :limit => 4,                                                   :null => false
    t.string   "trans_no",                 :limit => 18,                                                  :null => false
    t.datetime "trans_date",                                                                              :null => false
    t.string   "account_period_code",      :limit => 8,                                                   :null => false
    t.integer  "customer_id"
    t.string   "customer_code",            :limit => 50
    t.string   "customer_name",            :limit => 50
    t.string   "ship_to",                  :limit => 250
    t.datetime "ship_date"
    t.string   "serial_no",                :limit => 6
    t.integer  "catalog_item_id",                                                                         :null => false
    t.string   "catalog_item_code",        :limit => 250
    t.string   "size",                     :limit => 10
    t.decimal  "item_qty",                                :precision => 10, :scale => 2
    t.decimal  "item_price",                              :precision => 12, :scale => 2
    t.string   "item_type",                :limit => 1
    t.string   "catalog_item_category",    :limit => 250
    t.string   "catalog_item_description", :limit => 250
    t.decimal  "item_amt",                                :precision => 12, :scale => 2
    t.decimal  "clear_qty",                               :precision => 10, :scale => 2
    t.string   "ext_ref_no",               :limit => 25
    t.datetime "ext_ref_date"
    t.string   "ref_trans_no",             :limit => 18
    t.datetime "ref_trans_date"
    t.datetime "cancel_date"
    t.decimal  "cancel_qty",                              :precision => 10, :scale => 2
  end

  create_table "catalog_open_orders", :force => true do |t|
    t.integer  "company_id",                                                                              :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                           :default => 0
    t.string   "trans_bk",                 :limit => 4,                                                   :null => false
    t.string   "trans_no",                 :limit => 18,                                                  :null => false
    t.datetime "trans_date",                                                                              :null => false
    t.string   "account_period_code",      :limit => 8,                                                   :null => false
    t.integer  "customer_id"
    t.string   "customer_code",            :limit => 50
    t.string   "customer_name",            :limit => 50
    t.string   "ship_to",                  :limit => 250
    t.datetime "ship_date"
    t.string   "serial_no",                :limit => 6
    t.integer  "catalog_item_id",                                                                         :null => false
    t.string   "catalog_item_code",        :limit => 250
    t.string   "size",                     :limit => 10
    t.decimal  "item_qty",                                :precision => 10, :scale => 2
    t.decimal  "item_price",                              :precision => 12, :scale => 2
    t.string   "item_type",                :limit => 1
    t.string   "catalog_item_category",    :limit => 250
    t.string   "catalog_item_description", :limit => 250
    t.decimal  "item_amt",                                :precision => 12, :scale => 2
    t.decimal  "clear_qty",                               :precision => 10, :scale => 2
    t.string   "ext_ref_no",               :limit => 25
    t.datetime "ext_ref_date"
    t.string   "ref_trans_no",             :limit => 18
    t.datetime "ref_trans_date"
    t.datetime "cancel_date"
    t.decimal  "cancel_qty",                              :precision => 10, :scale => 2
  end

  create_table "catalog_open_receivables", :force => true do |t|
    t.integer  "company_id",                                                                  :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",   :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                               :default => 0
    t.string   "account_id",   :limit => 18
    t.string   "name",         :limit => 100
    t.string   "trans_period", :limit => 8
    t.string   "trans_bk",     :limit => 4
    t.string   "trans_no",     :limit => 10
    t.string   "inv_no",       :limit => 15
    t.datetime "trans_dt"
    t.string   "terms",        :limit => 8
    t.datetime "due_dt"
    t.decimal  "inv_amt",                     :precision => 12, :scale => 2
    t.decimal  "balance_amt",                 :precision => 12, :scale => 2
  end

  create_table "catalog_order_cancel_lines", :force => true do |t|
    t.integer  "company_id",                                                            :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                          :default => 0
    t.integer  "user_id",                                                               :default => 0
    t.integer  "catalog_order_cancel_id",                                                                :null => false
    t.integer  "catalog_item_id",                                                                        :null => false
    t.datetime "ship_date"
    t.datetime "cancel_date"
    t.integer  "qty",                                                                                    :null => false
    t.decimal  "item_price",                             :precision => 12, :scale => 2
    t.decimal  "discount",                               :precision => 12, :scale => 2
    t.decimal  "amount",                                 :precision => 12, :scale => 2
    t.string   "trans_bk",                 :limit => 4
    t.string   "ref_trans_bk",             :limit => 4
    t.string   "trans_no",                 :limit => 18
    t.string   "ref_trans_no",             :limit => 18
    t.datetime "trans_date"
    t.datetime "ref_trans_date"
    t.string   "serial_no",                :limit => 6
    t.integer  "catalog_item_packet_id"
    t.string   "catalog_item_packet_code", :limit => 25
    t.string   "spl_order_flag",           :limit => 1,                                 :default => "N"
    t.string   "size",                     :limit => 10
    t.string   "metal_color",              :limit => 10
    t.string   "diamond",                  :limit => 10
    t.string   "metal_type",               :limit => 10
    t.string   "pearl_type",               :limit => 10
    t.string   "pearl_color",              :limit => 10
    t.string   "pearl_size",               :limit => 10
    t.string   "remarks"
  end

  create_table "catalog_order_cancels", :force => true do |t|
    t.integer  "company_id",                                                      :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",       :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",        :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                    :default => 0
    t.integer  "user_id",                                                         :default => 0
    t.integer  "customer_id",                                                     :default => 0
    t.string   "order_no",          :limit => 50,                                 :default => " "
    t.datetime "order_date"
    t.string   "status",            :limit => 1,                                  :default => "N"
    t.string   "name",              :limit => 50,                                 :default => " "
    t.string   "bill_address1",     :limit => 40,                                 :default => " "
    t.string   "bill_address2",     :limit => 40,                                 :default => " "
    t.string   "bill_city",         :limit => 20,                                 :default => " "
    t.string   "bill_state",        :limit => 5,                                  :default => " "
    t.string   "bill_zip",          :limit => 15,                                 :default => " "
    t.string   "bill_country",      :limit => 20,                                 :default => " "
    t.string   "ship_address1",     :limit => 40,                                 :default => " "
    t.string   "ship_address2",     :limit => 40,                                 :default => " "
    t.string   "ship_city",         :limit => 20,                                 :default => " "
    t.string   "ship_state",        :limit => 5,                                  :default => " "
    t.string   "ship_zip",          :limit => 15,                                 :default => " "
    t.string   "ship_country",      :limit => 20,                                 :default => " "
    t.string   "phone1",            :limit => 15,                                 :default => " "
    t.string   "phone2",            :limit => 15,                                 :default => " "
    t.string   "fax1",              :limit => 15,                                 :default => " "
    t.string   "cell_no",           :limit => 15,                                 :default => " "
    t.string   "email",             :limit => 50,                                 :default => " "
    t.string   "comments",          :limit => 200,                                :default => " "
    t.decimal  "item_qty",                         :precision => 10, :scale => 2
    t.decimal  "item_amt",                         :precision => 12, :scale => 2
    t.decimal  "ship_amt",                         :precision => 12, :scale => 2
    t.decimal  "tax_amt",                          :precision => 12, :scale => 2
    t.decimal  "net_amt",                          :precision => 12, :scale => 2
    t.datetime "planned_ship_date"
    t.datetime "actual_ship_date"
    t.datetime "cancel_date"
    t.string   "trans_bk",          :limit => 4
    t.string   "ref_trans_bk",      :limit => 4
    t.string   "trans_no",          :limit => 18
    t.string   "ref_trans_no",      :limit => 18
    t.datetime "trans_date"
    t.datetime "ref_trans_date"
    t.decimal  "discount_per",                     :precision => 6,  :scale => 2
    t.decimal  "discount_amt",                     :precision => 6,  :scale => 2
    t.string   "remarks"
    t.string   "ext_ref_no",        :limit => 50
    t.datetime "ext_ref_date"
  end

  create_table "catalog_order_lines", :force => true do |t|
    t.integer  "company_id",                                                             :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                           :default => 0
    t.integer  "user_id",                                                                :default => 0
    t.integer  "catalog_order_id",                                                                        :null => false
    t.integer  "catalog_item_id",                                                                         :null => false
    t.datetime "ship_date"
    t.datetime "cancel_date"
    t.decimal  "item_price",                              :precision => 12, :scale => 2
    t.decimal  "discount",                                :precision => 12, :scale => 2
    t.decimal  "amount",                                  :precision => 12, :scale => 2
    t.string   "trans_bk",                 :limit => 4
    t.string   "trans_no",                 :limit => 18
    t.datetime "trans_date"
    t.string   "serial_no",                :limit => 6
    t.integer  "catalog_item_packet_id"
    t.string   "catalog_item_packet_code", :limit => 25
    t.string   "spl_order_flag",           :limit => 1,                                  :default => "N"
    t.string   "size",                     :limit => 10
    t.string   "metal_color",              :limit => 10
    t.string   "diamond",                  :limit => 10
    t.string   "metal_type",               :limit => 10
    t.string   "pearl_size",               :limit => 10
    t.string   "pearl_color",              :limit => 10
    t.string   "pearl_type",               :limit => 10
    t.string   "remarks"
    t.decimal  "qty",                                     :precision => 10, :scale => 2
    t.decimal  "clear_qty",                               :precision => 10, :scale => 2
    t.string   "order_type",               :limit => 1,                                  :default => "O"
    t.string   "ship_to",                  :limit => 250
    t.decimal  "item_amt",                                :precision => 12, :scale => 2
    t.decimal  "discount_per",                            :precision => 6,  :scale => 2
    t.string   "item_description",         :limit => 250
    t.string   "account_period_code",      :limit => 8
    t.string   "spo_flag",                 :limit => 1,                                  :default => "N"
    t.string   "spo_size",                 :limit => 25
    t.string   "spo_head_size",            :limit => 25
    t.string   "spo_metal_type",           :limit => 25
    t.string   "spo_diamond_qlty",         :limit => 25
    t.string   "spo_metal_color",          :limit => 25
  end

  add_index "catalog_order_lines", ["catalog_order_id"], :name => "idx_catalog_order_lines_catalog_order_id"

  create_table "catalog_order_pg_transactions", :force => true do |t|
    t.integer  "company_id",                                              :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",            :limit => 1,    :default => "Y"
    t.string   "trans_flag",             :limit => 1,    :default => "A"
    t.integer  "lock_version",                           :default => 0
    t.integer  "catalog_order_id"
    t.string   "mc_gross",               :limit => 10
    t.string   "protection_eligibility", :limit => 15
    t.string   "payer_id",               :limit => 25
    t.string   "address_street",         :limit => 100
    t.string   "payment_date",           :limit => 25
    t.string   "payment_status",         :limit => 15
    t.string   "charset",                :limit => 15
    t.string   "address_zip",            :limit => 15
    t.string   "mc_shipping",            :limit => 50
    t.string   "mc_handling",            :limit => 50
    t.string   "first_name",             :limit => 100
    t.string   "mc_fee",                 :limit => 15
    t.string   "address_country_code",   :limit => 15
    t.string   "address_name",           :limit => 50
    t.string   "notify_version",         :limit => 10
    t.string   "reason_code",            :limit => 50
    t.string   "custom",                 :limit => 50
    t.string   "business",               :limit => 50
    t.string   "address_country",        :limit => 15
    t.string   "address_city",           :limit => 25
    t.string   "verify_sign",            :limit => 100
    t.string   "payer_email",            :limit => 100
    t.string   "parent_txn_id",          :limit => 50
    t.string   "txn_id",                 :limit => 50
    t.string   "payment_type",           :limit => 25
    t.string   "last_name",              :limit => 50
    t.string   "address_state",          :limit => 25
    t.string   "receiver_email",         :limit => 50
    t.string   "payment_fee",            :limit => 15
    t.string   "shipping_discount",      :limit => 15
    t.string   "quantity",               :limit => 10
    t.string   "insurance_amount",       :limit => 15
    t.string   "receiver_id",            :limit => 50
    t.string   "discount",               :limit => 15
    t.string   "mc_currency",            :limit => 10
    t.string   "residence_country",      :limit => 25
    t.string   "test_ipn",               :limit => 50
    t.string   "shipping_method",        :limit => 25
    t.string   "transaction_subject",    :limit => 50
    t.string   "payment_gross",          :limit => 15
    t.string   "invoice",                :limit => 25
    t.string   "transaction_text",       :limit => 1500
    t.string   "tax",                    :limit => 15
    t.string   "txn_type",               :limit => 15
    t.string   "item_name",              :limit => 50
    t.string   "action",                 :limit => 15
    t.string   "pending_reason",         :limit => 50
    t.string   "payer_status",           :limit => 15
    t.string   "controller",             :limit => 50
    t.string   "address_status",         :limit => 15
    t.string   "num_cart_items",         :limit => 5
    t.string   "receipt_id",             :limit => 25
  end

  create_table "catalog_orders", :force => true do |t|
    t.integer  "company_id",                                                        :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                      :default => 0
    t.integer  "user_id",                                                           :default => 0
    t.integer  "customer_id",                                                       :default => 0
    t.string   "order_no",            :limit => 50,                                 :default => " "
    t.datetime "order_date"
    t.string   "status",              :limit => 1,                                  :default => "N"
    t.string   "name",                :limit => 50,                                 :default => " "
    t.string   "bill_address1",       :limit => 40,                                 :default => " "
    t.string   "bill_address2",       :limit => 40,                                 :default => " "
    t.string   "bill_city",           :limit => 20,                                 :default => " "
    t.string   "bill_state",          :limit => 5,                                  :default => " "
    t.string   "bill_zip",            :limit => 15,                                 :default => " "
    t.string   "bill_country",        :limit => 20,                                 :default => " "
    t.string   "ship_address1",       :limit => 40,                                 :default => " "
    t.string   "ship_address2",       :limit => 40,                                 :default => " "
    t.string   "ship_city",           :limit => 20,                                 :default => " "
    t.string   "ship_state",          :limit => 5,                                  :default => " "
    t.string   "ship_zip",            :limit => 15,                                 :default => " "
    t.string   "ship_country",        :limit => 20,                                 :default => " "
    t.string   "phone1",              :limit => 15,                                 :default => " "
    t.string   "phone2",              :limit => 15,                                 :default => " "
    t.string   "fax1",                :limit => 15,                                 :default => " "
    t.string   "cell_no",             :limit => 15,                                 :default => " "
    t.string   "email",               :limit => 50,                                 :default => " "
    t.string   "comments",            :limit => 200,                                :default => " "
    t.datetime "planned_ship_date"
    t.datetime "actual_ship_date"
    t.datetime "cancel_date"
    t.string   "trans_bk",            :limit => 4
    t.string   "trans_no",            :limit => 18
    t.datetime "trans_date"
    t.string   "payment_type",        :limit => 1,                                  :default => "P"
    t.string   "payment_receipt_id",  :limit => 25
    t.string   "payment_status",      :limit => 1,                                  :default => "U"
    t.datetime "payment_date"
    t.string   "first_name",          :limit => 50
    t.string   "last_name",           :limit => 50
    t.string   "pg_transaction_id",   :limit => 100
    t.decimal  "item_qty",                           :precision => 10, :scale => 2
    t.decimal  "item_amt",                           :precision => 12, :scale => 2
    t.decimal  "ship_amt",                           :precision => 12, :scale => 2
    t.decimal  "tax_amt",                            :precision => 12, :scale => 2
    t.decimal  "net_amt",                            :precision => 12, :scale => 2
    t.decimal  "discount_per",                       :precision => 6,  :scale => 2
    t.decimal  "discount_amt",                       :precision => 6,  :scale => 2
    t.string   "remarks"
    t.string   "ext_ref_no",          :limit => 50
    t.datetime "ext_ref_date"
    t.string   "salesperson_code",    :limit => 25
    t.string   "account_period_code", :limit => 8
    t.integer  "ref_id"
    t.string   "signature_file_name", :limit => 100
  end

  add_index "catalog_orders", ["customer_id"], :name => "catalog_orders_customer_id"

  create_table "catalog_parameters", :force => true do |t|
    t.integer  "company_id",                                :default => 1,        :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",               :limit => 1,    :default => "Y"
    t.string   "trans_flag",                :limit => 1,    :default => "A"
    t.integer  "lock_version",                              :default => 0
    t.string   "company_logo_file",         :limit => 100
    t.string   "company_short_name",        :limit => 50
    t.string   "company_full_name",         :limit => 100
    t.string   "online_inquiries",          :limit => 100
    t.string   "store_inquires_contact_no", :limit => 50
    t.string   "store_inquires",            :limit => 50
    t.string   "personalshopper",           :limit => 50
    t.string   "address1",                  :limit => 50
    t.string   "address2",                  :limit => 50
    t.string   "city",                      :limit => 25
    t.string   "state",                     :limit => 25
    t.string   "zip",                       :limit => 15
    t.string   "country",                   :limit => 20
    t.string   "phone",                     :limit => 50
    t.string   "fax",                       :limit => 50
    t.string   "merchant_id",               :limit => 100
    t.string   "return_url",                :limit => 1000
    t.string   "pdt_identity_token",        :limit => 150
    t.string   "paypal_enable_flag",        :limit => 1,    :default => "N"
    t.string   "ipn_server",                :limit => 200
    t.string   "paypal_business_email",     :limit => 100
    t.string   "theme_type",                :limit => 25,   :default => "BLACK"
    t.string   "secure_access",             :limit => 1,    :default => "N"
    t.string   "catalog_invn_check",        :limit => 1,    :default => "N"
    t.string   "integrated_application",    :limit => 25,   :default => "RETAIL"
    t.string   "itemmultipleimageflag",     :limit => 1,    :default => "N"
    t.string   "customer_price_flag",       :limit => 1,    :default => ""
    t.string   "application_host_flag",     :limit => 1,    :default => "S"
    t.string   "show_price_flag",           :limit => 1,    :default => "Y"
  end

  create_table "catalog_private_policies", :force => true do |t|
    t.integer  "company_id",                       :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",      :limit => 1,    :default => "Y"
    t.string   "trans_flag",       :limit => 1,    :default => "A"
    t.integer  "lock_version",                     :default => 0
    t.string   "heading",          :limit => 100
    t.string   "paragraph",        :limit => 3000
    t.string   "link1_text",       :limit => 100
    t.string   "link1_url",        :limit => 100
    t.string   "link2_text",       :limit => 100
    t.string   "link2_url",        :limit => 100
    t.string   "link3_text",       :limit => 100
    t.string   "link3_url",        :limit => 100
    t.integer  "sequence"
    t.string   "diaspark_default", :limit => 1,    :default => "N"
  end

  create_table "catalog_promotions", :force => true do |t|
    t.integer  "company_id",                   :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",   :limit => 1,   :default => "Y"
    t.string   "trans_flag",    :limit => 1,   :default => "A"
    t.integer  "lock_version",                 :default => 0
    t.string   "image1",        :limit => 100
    t.string   "image2",        :limit => 100
    t.string   "image3",        :limit => 100
    t.string   "image4",        :limit => 100
    t.string   "image1_link",   :limit => 100
    t.string   "image2_link",   :limit => 100
    t.string   "image3_link",   :limit => 100
    t.string   "image4_link",   :limit => 100
    t.string   "template_type", :limit => 25
  end

  create_table "catalog_store_locations", :force => true do |t|
    t.integer  "company_id",                  :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,   :default => "Y"
    t.string   "trans_flag",   :limit => 1,   :default => "A"
    t.integer  "lock_version",                :default => 0
    t.string   "code",         :limit => 25,                   :null => false
    t.string   "name",         :limit => 50
    t.string   "description",  :limit => 500
    t.integer  "sequence"
  end

  create_table "catalog_usage_terms", :force => true do |t|
    t.integer  "company_id",                       :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",      :limit => 1,    :default => "Y"
    t.string   "trans_flag",       :limit => 1,    :default => "A"
    t.integer  "lock_version",                     :default => 0
    t.string   "heading",          :limit => 100
    t.string   "paragraph",        :limit => 3000
    t.string   "link1_text",       :limit => 100
    t.string   "link1_url",        :limit => 100
    t.string   "link2_text",       :limit => 100
    t.string   "link2_url",        :limit => 100
    t.string   "link3_text",       :limit => 100
    t.string   "link3_url",        :limit => 100
    t.integer  "sequence"
    t.string   "diaspark_default", :limit => 1,    :default => "Y"
  end

  create_table "companies", :force => true do |t|
    t.integer  "company_id",                          :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,    :default => "Y"
    t.string   "trans_flag",          :limit => 1,    :default => "A"
    t.integer  "lock_version",                        :default => 0
    t.string   "company_cd",          :limit => 25,                    :null => false
    t.string   "name",                :limit => 50
    t.string   "address1",            :limit => 50
    t.string   "address2",            :limit => 50
    t.string   "city",                :limit => 25
    t.string   "state",               :limit => 25
    t.string   "zip",                 :limit => 15
    t.string   "phone",               :limit => 50
    t.string   "fax",                 :limit => 50
    t.string   "remarks",             :limit => 50
    t.string   "aboutus",             :limit => 1000
    t.string   "country",             :limit => 20
    t.string   "cell_no",             :limit => 15
    t.string   "email_to",            :limit => 200
    t.string   "email_cc",            :limit => 200
    t.string   "city_tax_code",       :limit => 50
    t.string   "state_tax_code",      :limit => 50
    t.string   "country_tax_code",    :limit => 50
    t.string   "company_type",        :limit => 1
    t.integer  "default_customer_id"
    t.integer  "default_vendor_id"
    t.string   "company_logo_file",   :limit => 100
    t.string   "company_name",        :limit => 100
    t.string   "business_card",       :limit => 100
  end

  create_table "contractor_memos", :force => true do |t|
    t.integer  "company_id",                                                                             :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                          :default => 0
    t.string   "trans_bk",                 :limit => 4,                                                  :null => false
    t.string   "trans_no",                 :limit => 18,                                                 :null => false
    t.datetime "trans_date"
    t.string   "trans_type",               :limit => 1
    t.string   "account_period_code",      :limit => 8,                                                  :null => false
    t.string   "ref_trans_id",             :limit => 4
    t.string   "ref_trans_bk",             :limit => 4
    t.string   "ref_trans_no",             :limit => 18
    t.datetime "ref_trans_date"
    t.string   "ref_type",                 :limit => 1
    t.integer  "contractor_id"
    t.string   "bill_name",                :limit => 50
    t.string   "bill_address1",            :limit => 50
    t.string   "bill_address2",            :limit => 50
    t.string   "bill_city",                :limit => 25
    t.string   "bill_state",               :limit => 25
    t.string   "bill_zip",                 :limit => 15
    t.string   "bill_country",             :limit => 20
    t.string   "bill_phone",               :limit => 50
    t.string   "bill_fax",                 :limit => 50
    t.integer  "store_id"
    t.string   "ship_name",                :limit => 50
    t.string   "ship_address1",            :limit => 50
    t.string   "ship_address2",            :limit => 50
    t.string   "ship_city",                :limit => 25
    t.string   "ship_state",               :limit => 25
    t.string   "ship_zip",                 :limit => 15
    t.string   "ship_country",             :limit => 20
    t.string   "ship_phone",               :limit => 50
    t.string   "ship_fax",                 :limit => 50
    t.string   "ext_ref_no",               :limit => 50
    t.datetime "ext_ref_date"
    t.datetime "memo_date"
    t.string   "term_code",                :limit => 25
    t.datetime "cancel_date"
    t.datetime "due_date"
    t.datetime "ship_date"
    t.string   "shipping_code",            :limit => 25
    t.string   "tracking_no",              :limit => 50
    t.string   "post_flag",                :limit => 1
    t.decimal  "memo_qty",                               :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                              :precision => 6,  :scale => 2, :default => 0.0
    t.integer  "catalog_item_id"
    t.string   "catalog_item_code"
    t.string   "catalog_item_description", :limit => 50
    t.integer  "catalog_item_packet_id"
    t.string   "catalog_item_packet_code", :limit => 25
    t.string   "vendor_instruction"
    t.string   "metal_type",               :limit => 25
    t.string   "metal_color",              :limit => 25
    t.decimal  "metal_weight",                           :precision => 12, :scale => 4
    t.integer  "stone_lot_id"
    t.string   "stone_lot_number",         :limit => 25
    t.integer  "stone_packet_id"
    t.string   "stone_packet_code",        :limit => 25
    t.string   "stone_type",               :limit => 4
    t.string   "stone_shape",              :limit => 18
    t.decimal  "stone_size",                             :precision => 7,  :scale => 2
    t.string   "stone_quality",            :limit => 18
    t.string   "stone_color",              :limit => 18
    t.string   "stone_clarity",            :limit => 18
    t.string   "stone_setting",            :limit => 18
    t.decimal  "stone_weight",                           :precision => 8,  :scale => 4
    t.integer  "stone_qty",                              :precision => 5,  :scale => 0
    t.string   "length",                   :limit => 25
    t.string   "finish",                   :limit => 25
    t.string   "size",                     :limit => 25
    t.decimal  "discount_per",                           :precision => 6,  :scale => 2
    t.decimal  "discount_amt",                           :precision => 12, :scale => 2
    t.decimal  "tax_per",                                :precision => 6,  :scale => 3
    t.decimal  "tax_amt",                                :precision => 12, :scale => 2
    t.decimal  "other_amt",                              :precision => 12, :scale => 2
    t.decimal  "ship_amt",                               :precision => 12, :scale => 2
    t.decimal  "item_amt",                               :precision => 12, :scale => 2
    t.decimal  "net_amt",                                :precision => 12, :scale => 2
    t.string   "remarks"
    t.string   "item_type",                :limit => 1
    t.decimal  "item_price",                             :precision => 10, :scale => 2, :default => 0.0
  end

  create_table "criteria_users", :force => true do |t|
    t.integer  "company_id",                                 :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1, :default => "Y"
    t.string   "trans_flag",   :limit => 1, :default => "A"
    t.integer  "lock_version",              :default => 0
    t.integer  "criteria_id",                                :null => false
    t.integer  "user_id",                                    :null => false
    t.string   "default_yn",   :limit => 1, :default => "N"
    t.integer  "document_id",               :default => 0,   :null => false
  end

  create_table "criterias", :force => true do |t|
    t.integer  "company_id",                                                    :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",     :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",      :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                  :default => 0
    t.string   "name",            :limit => 50
    t.string   "criteria_type",   :limit => 20
    t.integer  "user_id"
    t.integer  "document_id",                                                                    :null => false
    t.string   "str1",            :limit => 25
    t.string   "str2",            :limit => 25
    t.string   "str3",            :limit => 25
    t.string   "str4",            :limit => 25
    t.string   "str5",            :limit => 25
    t.string   "str6",            :limit => 25
    t.string   "str7",            :limit => 25
    t.string   "str8",            :limit => 25
    t.string   "str9",            :limit => 25
    t.string   "str10",           :limit => 25
    t.string   "str11",           :limit => 25
    t.string   "str12",           :limit => 25
    t.string   "str13",           :limit => 25
    t.string   "str14",           :limit => 25
    t.string   "str15",           :limit => 25
    t.string   "str16",           :limit => 25
    t.string   "str17",           :limit => 25
    t.string   "str18",           :limit => 25
    t.string   "str19",           :limit => 25
    t.string   "str20",           :limit => 25
    t.string   "str21",           :limit => 25
    t.string   "str22",           :limit => 25
    t.string   "str23",           :limit => 25
    t.string   "str24",           :limit => 25
    t.string   "str25",           :limit => 25
    t.datetime "dt1"
    t.datetime "dt2"
    t.datetime "dt3"
    t.datetime "dt4"
    t.datetime "dt5"
    t.datetime "dt6"
    t.datetime "dt7"
    t.datetime "dt8"
    t.datetime "dt9"
    t.datetime "dt10"
    t.decimal  "dec1",                           :precision => 12, :scale => 2
    t.decimal  "dec2",                           :precision => 12, :scale => 2
    t.decimal  "dec3",                           :precision => 12, :scale => 2
    t.decimal  "dec4",                           :precision => 12, :scale => 2
    t.decimal  "dec5",                           :precision => 12, :scale => 2
    t.decimal  "dec6",                           :precision => 12, :scale => 2
    t.decimal  "dec7",                           :precision => 12, :scale => 2
    t.decimal  "dec8",                           :precision => 12, :scale => 2
    t.decimal  "dec9",                           :precision => 12, :scale => 2
    t.decimal  "dec10",                          :precision => 12, :scale => 2
    t.integer  "int1"
    t.integer  "int2"
    t.integer  "int3"
    t.integer  "int4"
    t.integer  "int5"
    t.integer  "int6"
    t.integer  "int7"
    t.integer  "int8"
    t.integer  "int9"
    t.integer  "int10"
    t.string   "list1",           :limit => 5
    t.string   "list2",           :limit => 5
    t.string   "list3",           :limit => 5
    t.string   "list4",           :limit => 5
    t.string   "list5",           :limit => 5
    t.string   "list6",           :limit => 5
    t.string   "list7",           :limit => 5
    t.string   "list8",           :limit => 5
    t.string   "list9",           :limit => 5
    t.string   "list10",          :limit => 5
    t.string   "all1",            :limit => 1
    t.string   "all2",            :limit => 1
    t.string   "all3",            :limit => 1
    t.string   "all4",            :limit => 1
    t.string   "all5",            :limit => 1
    t.string   "all6",            :limit => 1
    t.string   "all7",            :limit => 1
    t.string   "all8",            :limit => 1
    t.string   "all9",            :limit => 1
    t.string   "all10",           :limit => 1
    t.string   "multiselect1",    :limit => 125
    t.string   "multiselect2",    :limit => 125
    t.string   "multiselect3",    :limit => 125
    t.string   "multiselect4",    :limit => 125
    t.string   "multiselect5",    :limit => 125
    t.string   "multiselect6",    :limit => 125
    t.string   "multiselect7",    :limit => 125
    t.string   "multiselect8",    :limit => 125
    t.string   "multiselect9",    :limit => 125
    t.string   "multiselect10",   :limit => 100
    t.string   "lookup_name",     :limit => 25
    t.string   "whereclause",     :limit => 100
    t.string   "default_request", :limit => 1,                                  :default => "N"
    t.string   "str26",           :limit => 25
    t.string   "str27",           :limit => 25
    t.string   "str28",           :limit => 25
    t.string   "str29",           :limit => 25
    t.string   "str30",           :limit => 25
    t.string   "multiselect11",   :limit => 125
    t.string   "multiselect12",   :limit => 125
    t.string   "multiselect13",   :limit => 125
    t.string   "multiselect14",   :limit => 125
    t.string   "multiselect15",   :limit => 125
  end

  create_table "crm_account_categories", :force => true do |t|
    t.integer  "company_id",                 :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,  :default => "Y"
    t.string   "trans_flag",   :limit => 1,  :default => "A"
    t.integer  "lock_version",               :default => 0
    t.string   "code",         :limit => 25
    t.string   "name",         :limit => 50
  end

  create_table "crm_accounts", :force => true do |t|
    t.integer  "company_id",                                                             :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                           :default => 0
    t.integer  "parent_account_id"
    t.integer  "crm_account_category_id"
    t.integer  "primary_contact_id"
    t.string   "relationship_type",        :limit => 50
    t.string   "address_type",             :limit => 50
    t.string   "business_territory",       :limit => 50
    t.string   "industry",                 :limit => 50
    t.string   "ownership_type",           :limit => 50
    t.string   "preferred_contact_method", :limit => 50
    t.string   "prefered_contact_time",    :limit => 50
    t.string   "prefered_contact_day",     :limit => 50
    t.string   "name",                     :limit => 50
    t.string   "account_number",           :limit => 50
    t.string   "address_name",             :limit => 50
    t.string   "address1",                 :limit => 50
    t.string   "address2",                 :limit => 50
    t.string   "phone",                    :limit => 50
    t.string   "fax",                      :limit => 50
    t.string   "email",                    :limit => 50
    t.string   "website",                  :limit => 50
    t.string   "city",                     :limit => 25,                                 :default => ""
    t.string   "state",                    :limit => 25,                                 :default => ""
    t.string   "zip",                      :limit => 15,                                 :default => ""
    t.string   "country",                  :limit => 20,                                 :default => ""
    t.string   "ship_via_code",            :limit => 25,                                 :default => ""
    t.string   "term_code",                :limit => 25,                                 :default => ""
    t.decimal  "annual_revenue",                          :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "credit_limit",                            :precision => 12, :scale => 2, :default => 0.0
    t.integer  "no_of_employees",                                                        :default => 0
    t.string   "description",              :limit => 100
    t.string   "credit_hold_flag",         :limit => 1
    t.string   "allow_email",              :limit => 1
    t.string   "allow_phone_call",         :limit => 1
    t.string   "allow_fax",                :limit => 1
    t.string   "allow_mail",               :limit => 1
    t.string   "send_marketing_material",  :limit => 1
    t.string   "account_rating",           :limit => 1,                                  :default => " "
    t.string   "account_source",           :limit => 50
    t.string   "saluation",                :limit => 50
    t.string   "first_name",               :limit => 50
    t.string   "last_name",                :limit => 50
  end

  create_table "crm_activities", :force => true do |t|
    t.integer  "company_id",                        :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",        :limit => 1,   :default => "Y"
    t.string   "trans_flag",         :limit => 1,   :default => "A"
    t.integer  "lock_version",                      :default => 0
    t.datetime "trans_date"
    t.datetime "due_date"
    t.integer  "performed_user_id"
    t.integer  "crm_account_id"
    t.integer  "crm_contact_id"
    t.integer  "crm_task_id"
    t.string   "subject",            :limit => 50
    t.string   "description",        :limit => 200
    t.integer  "crm_opportunity_id"
    t.string   "trans_bk",           :limit => 4
    t.string   "trans_no",           :limit => 18
  end

  create_table "crm_addresses", :force => true do |t|
    t.integer  "company_id",                     :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",      :limit => 1,  :default => "Y"
    t.string   "trans_flag",       :limit => 1,  :default => "A"
    t.integer  "lock_version",                   :default => 0
    t.string   "address_for_flag", :limit => 1
    t.integer  "address_for_id"
    t.string   "address_name",     :limit => 50
    t.string   "address1",         :limit => 50
    t.string   "address2",         :limit => 50
    t.string   "phone",            :limit => 50
    t.string   "fax",              :limit => 50
    t.string   "email",            :limit => 50
    t.string   "address_contact",  :limit => 50
    t.string   "city",             :limit => 25, :default => ""
    t.string   "state",            :limit => 25, :default => ""
    t.string   "zip",              :limit => 15, :default => ""
    t.string   "country",          :limit => 20, :default => ""
  end

  create_table "crm_contacts", :force => true do |t|
    t.integer  "company_id",                                                            :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                          :default => 0
    t.integer  "crm_account_id"
    t.string   "salutation",               :limit => 4
    t.string   "first_name",               :limit => 50
    t.string   "last_name",                :limit => 50
    t.string   "job_title",                :limit => 50
    t.string   "department",               :limit => 50
    t.string   "manager",                  :limit => 50
    t.string   "spouse_name",              :limit => 50
    t.string   "address_name",             :limit => 50
    t.string   "address1",                 :limit => 50
    t.string   "address2",                 :limit => 50
    t.string   "business_phone",           :limit => 50
    t.string   "manager_phone",            :limit => 50
    t.string   "home_phone",               :limit => 50
    t.string   "cell_phone",               :limit => 50
    t.string   "fax",                      :limit => 50
    t.string   "email",                    :limit => 50
    t.string   "city",                     :limit => 25,                                :default => ""
    t.string   "state",                    :limit => 25,                                :default => ""
    t.string   "zip",                      :limit => 15,                                :default => ""
    t.string   "country",                  :limit => 20,                                :default => ""
    t.string   "address_type",             :limit => 50
    t.string   "role",                     :limit => 50
    t.string   "preferred_contact_method", :limit => 50
    t.string   "gender",                   :limit => 15
    t.string   "marital_status",           :limit => 15
    t.datetime "date_of_birth"
    t.datetime "date_of_marraige"
    t.decimal  "credit_limit",                           :precision => 12, :scale => 2, :default => 0.0
    t.string   "credit_hold_flag",         :limit => 1
    t.string   "allow_email",              :limit => 1
    t.string   "allow_phone_call",         :limit => 1
    t.string   "allow_fax",                :limit => 1
    t.string   "allow_mail",               :limit => 1
    t.string   "send_marketing_material",  :limit => 1
    t.string   "prefered_contact_time",    :limit => 50
    t.string   "prefered_contact_day",     :limit => 50
    t.string   "prefered_contact",         :limit => 50
    t.string   "code",                     :limit => 25
  end

  create_table "crm_leads", :force => true do |t|
    t.integer  "company_id",                                                                          :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",          :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",           :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                       :default => 0
    t.string   "topic",                :limit => 100
    t.string   "first_name",           :limit => 50
    t.string   "last_name",            :limit => 50
    t.string   "name",                 :limit => 50
    t.integer  "crm_lead_category_id"
    t.integer  "account_id"
    t.string   "relationship_type",    :limit => 50
    t.string   "address_type",         :limit => 50
    t.string   "business_territory",   :limit => 50
    t.string   "industry",             :limit => 50
    t.string   "ownership_type",       :limit => 50
    t.string   "lead_number",          :limit => 50
    t.string   "account_number",       :limit => 50
    t.string   "address_name",         :limit => 50
    t.string   "address1",             :limit => 50
    t.string   "address2",             :limit => 50
    t.string   "phone",                :limit => 50
    t.string   "fax",                  :limit => 50
    t.string   "email",                :limit => 50
    t.string   "website",              :limit => 50
    t.string   "city",                 :limit => 25
    t.string   "state",                :limit => 25
    t.string   "zip",                  :limit => 15
    t.string   "country",              :limit => 20
    t.string   "business_phone",       :limit => 50
    t.string   "home_phone",           :limit => 50
    t.string   "other_phone",          :limit => 50
    t.string   "mobile_phone",         :limit => 50
    t.string   "pager",                :limit => 50
    t.string   "lead_source",          :limit => 50
    t.string   "rating",               :limit => 50
    t.string   "job_title",            :limit => 50
    t.string   "saluation",            :limit => 50
    t.decimal  "annual_revenue",                      :precision => 12, :scale => 2, :default => 0.0
    t.string   "description",          :limit => 100
    t.integer  "no_of_employees"
    t.datetime "last_followed_date"
    t.datetime "next_followed_date"
    t.datetime "lead_date"
  end

  create_table "crm_opportunities", :force => true do |t|
    t.integer  "company_id",                                                     :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",      :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",       :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                   :default => 0
    t.string   "name",             :limit => 50
    t.string   "opportunity_type", :limit => 50
    t.string   "stage",            :limit => 50
    t.integer  "crm_account_id"
    t.datetime "close_date"
    t.decimal  "probability_per",                 :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "amount",                          :precision => 12, :scale => 2, :default => 0.0
    t.string   "subject",          :limit => 100
    t.string   "description",      :limit => 200
  end

  create_table "crm_relationships", :force => true do |t|
    t.integer  "company_id",                :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1, :default => "Y"
    t.string   "trans_flag",   :limit => 1, :default => "A"
    t.integer  "lock_version",              :default => 0
    t.integer  "party1_id"
    t.integer  "party2_id"
    t.string   "description"
  end

  create_table "crm_tasks", :force => true do |t|
    t.integer  "company_id",                       :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",       :limit => 1,   :default => "Y"
    t.string   "trans_flag",        :limit => 1,   :default => "A"
    t.integer  "lock_version",                     :default => 0
    t.datetime "trans_date"
    t.datetime "due_date"
    t.datetime "end_date"
    t.datetime "start_date"
    t.datetime "reminder_datetime"
    t.integer  "crm_account_id"
    t.integer  "assigned_user_id"
    t.integer  "crm_contact_id"
    t.integer  "duration"
    t.string   "description",       :limit => 100
    t.string   "subject",           :limit => 50
    t.string   "status",            :limit => 50
    t.string   "priority",          :limit => 50
    t.string   "location",          :limit => 50
    t.string   "reminder_flag",     :limit => 1
    t.string   "trans_bk",          :limit => 4
    t.string   "trans_no",          :limit => 18
  end

  create_table "customer_activities", :force => true do |t|
    t.integer  "company_id",                                               :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,   :default => "Y"
    t.string   "trans_flag",               :limit => 1,   :default => "A"
    t.integer  "lock_version",                            :default => 0
    t.integer  "customer_id"
    t.string   "trans_bk",                 :limit => 4
    t.string   "trans_no",                 :limit => 18
    t.datetime "trans_date"
    t.string   "trans_type",               :limit => 1
    t.string   "catalog_item_code",        :limit => 25
    t.string   "catalog_item_description", :limit => 200
    t.string   "catalog_item_price",       :limit => 25
  end

  create_table "customer_categories", :force => true do |t|
    t.integer  "company_id",                                                            :default => 1,   :null => false
    t.integer  "created_by"
    t.datetime "created_at"
    t.integer  "updated_by"
    t.datetime "updated_at"
    t.string   "trans_flag",                :limit => 1,                                :default => "A"
    t.string   "update_flag",               :limit => 1,                                :default => "Y"
    t.integer  "lock_version",                                                          :default => 0
    t.string   "code",                      :limit => 25,                                                :null => false
    t.string   "name",                      :limit => 50
    t.decimal  "discount_per",                            :precision => 6, :scale => 2
    t.integer  "discount_days"
    t.integer  "due_days"
    t.string   "term_code",                 :limit => 25
    t.integer  "gl_accounts_receivable_id"
    t.integer  "gl_income_account_id"
    t.integer  "gl_discount_account_id"
  end

  create_table "customer_invoice_lines", :force => true do |t|
    t.integer  "company_id",                                                       :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                     :default => 0
    t.string   "trans_bk",            :limit => 4
    t.string   "trans_no",            :limit => 18
    t.datetime "trans_date"
    t.string   "serial_no",           :limit => 6
    t.integer  "customer_invoice_id"
    t.integer  "gl_account_id"
    t.decimal  "gl_amt",                            :precision => 12, :scale => 2
    t.string   "description",         :limit => 50
  end

  add_index "customer_invoice_lines", ["customer_invoice_id"], :name => "idx_customer_invoice_lines_customer_invoice_id"

  create_table "customer_invoices", :force => true do |t|
    t.integer  "company_id",                                                       :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                     :default => 0
    t.string   "trans_bk",            :limit => 4
    t.string   "trans_no",            :limit => 18
    t.datetime "trans_date"
    t.datetime "inv_date"
    t.datetime "due_date"
    t.datetime "discount_date"
    t.datetime "sale_date"
    t.string   "account_period_code", :limit => 8
    t.string   "post_flag",           :limit => 1
    t.string   "action_flag",         :limit => 1
    t.string   "clear_flag",          :limit => 1
    t.string   "trans_type",          :limit => 1
    t.string   "inv_type",            :limit => 4
    t.string   "inv_no",              :limit => 18
    t.integer  "customer_id"
    t.integer  "soldto_id"
    t.integer  "parent_id"
    t.string   "term_code",           :limit => 25
    t.string   "salesperson_code",    :limit => 25
    t.decimal  "inv_amt",                           :precision => 12, :scale => 2
    t.decimal  "discount_amt",                      :precision => 12, :scale => 2
    t.decimal  "paid_amt",                          :precision => 12, :scale => 2
    t.decimal  "disctaken_amt",                     :precision => 12, :scale => 2
    t.decimal  "balance_amt",                       :precision => 12, :scale => 2
    t.decimal  "clear_amt",                         :precision => 12, :scale => 2
    t.decimal  "item_qty",                          :precision => 12, :scale => 2
    t.decimal  "discount_per",                      :precision => 6,  :scale => 2
    t.string   "description",         :limit => 50
  end

  add_index "customer_invoices", ["customer_id"], :name => "customer_invoice_customer_id"

  create_table "customer_jbtrankings", :force => true do |t|
    t.integer  "company_id",                  :default => 1,   :null => false
    t.integer  "created_by",                  :default => 0
    t.datetime "created_at"
    t.integer  "updated_by",                  :default => 0
    t.datetime "updated_at"
    t.string   "trans_flag",   :limit => 1,   :default => "A"
    t.string   "update_flag",  :limit => 1,   :default => "A"
    t.integer  "lock_version",                :default => 0
    t.integer  "customer_id",                 :default => 0
    t.string   "serial_no",    :limit => 6
    t.datetime "ranking_date"
    t.string   "jbt_ranking",  :limit => 10
    t.string   "remarks",      :limit => 100
  end

  add_index "customer_jbtrankings", ["customer_id"], :name => "customer_jbtrankings_customer_id"

  create_table "customer_notes", :force => true do |t|
    t.integer  "company_id",                  :default => 1,   :null => false
    t.integer  "created_by",                  :default => 0
    t.datetime "created_at"
    t.integer  "updated_by",                  :default => 0
    t.datetime "updated_at"
    t.datetime "trans_dt"
    t.integer  "user_id",                     :default => 0
    t.string   "trans_flag",   :limit => 1,   :default => "A"
    t.string   "update_flag",  :limit => 1,   :default => "A"
    t.integer  "lock_version",                :default => 0
    t.integer  "customer_id",                 :default => 0
    t.string   "serial_no",    :limit => 6
    t.string   "daily_notes",  :limit => 100
  end

  add_index "customer_notes", ["customer_id"], :name => "customer_notes_customer_id"

  create_table "customer_receipt_lines", :force => true do |t|
    t.integer  "company_id",                                                       :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                     :default => 0
    t.string   "trans_bk",            :limit => 4
    t.string   "trans_no",            :limit => 18
    t.string   "voucher_no",          :limit => 18
    t.datetime "trans_date"
    t.datetime "voucher_date"
    t.datetime "due_date"
    t.string   "serial_no",           :limit => 6
    t.string   "voucher_flag",        :limit => 1
    t.string   "apply_flag",          :limit => 1
    t.integer  "customer_receipt_id"
    t.integer  "gl_account_id"
    t.decimal  "original_amt",                      :precision => 12, :scale => 2
    t.decimal  "apply_amt",                         :precision => 12, :scale => 2
    t.decimal  "balance_amt",                       :precision => 12, :scale => 2
    t.decimal  "disctaken_amt",                     :precision => 12, :scale => 2
    t.string   "apply_to",            :limit => 10
    t.string   "ref_no",              :limit => 20
  end

  add_index "customer_receipt_lines", ["customer_receipt_id"], :name => "idx_customer_receipt_lines_customer_receipt_id"

  create_table "customer_receipts", :force => true do |t|
    t.integer  "company_id",                                                       :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                     :default => 0
    t.string   "trans_bk",            :limit => 4
    t.string   "trans_no",            :limit => 18
    t.datetime "trans_date"
    t.datetime "check_date"
    t.datetime "due_date"
    t.string   "account_period_code", :limit => 8
    t.string   "post_flag",           :limit => 1
    t.string   "action_flag",         :limit => 1
    t.string   "trans_type",          :limit => 1
    t.string   "receipt_type",        :limit => 4
    t.integer  "customer_id"
    t.integer  "soldto_id"
    t.integer  "parent_id"
    t.integer  "bank_id"
    t.string   "term_code",           :limit => 25
    t.string   "salesperson_code",    :limit => 25
    t.decimal  "received_amt",                      :precision => 12, :scale => 2
    t.decimal  "applied_amt",                       :precision => 12, :scale => 2
    t.decimal  "balance_amt",                       :precision => 12, :scale => 2
    t.decimal  "item_qty",                          :precision => 12, :scale => 2
    t.string   "check_no",            :limit => 15
    t.string   "description",         :limit => 50
    t.integer  "deposit_no"
  end

  add_index "customer_receipts", ["customer_id"], :name => "customer_receipts_customer_id"

  create_table "customer_relationships", :force => true do |t|
    t.integer  "company_id",                                            :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",           :limit => 1,   :default => "Y"
    t.string   "trans_flag",            :limit => 1,   :default => "A"
    t.integer  "lock_version",                         :default => 0
    t.integer  "customer_id"
    t.string   "relationship",          :limit => 50
    t.string   "related_customer_code", :limit => 25
    t.string   "first_name",            :limit => 50
    t.string   "last_name",             :limit => 50
    t.string   "phone",                 :limit => 50
    t.string   "email",                 :limit => 100
    t.string   "birth_date",            :limit => 6
    t.string   "anniversary_date",      :limit => 6
  end

  create_table "customer_salespeople", :force => true do |t|
    t.integer  "company_id",                                     :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",      :limit => 1, :default => "Y"
    t.string   "trans_flag",       :limit => 1, :default => "A"
    t.integer  "lock_version",                  :default => 0
    t.integer  "customer_id"
    t.string   "customer_code"
    t.integer  "salesperson_id"
    t.string   "salesperson_code"
  end

  create_table "customer_shippings", :force => true do |t|
    t.integer  "company_id",                 :default => 1,   :null => false
    t.integer  "created_by",                 :default => 0
    t.datetime "created_at"
    t.integer  "updated_by",                 :default => 0
    t.datetime "updated_at"
    t.string   "trans_flag",   :limit => 1,  :default => "A"
    t.string   "update_flag",  :limit => 1,  :default => "A"
    t.integer  "lock_version",               :default => 0
    t.string   "code",         :limit => 25,                  :null => false
    t.string   "name",         :limit => 50, :default => ""
    t.integer  "customer_id",                :default => 0
    t.string   "serial_no",    :limit => 6
    t.string   "contact1",     :limit => 50, :default => ""
    t.string   "address1",     :limit => 50, :default => ""
    t.string   "address2",     :limit => 50, :default => ""
    t.string   "city",         :limit => 25, :default => ""
    t.string   "state",        :limit => 25, :default => ""
    t.string   "zip",          :limit => 15, :default => ""
    t.string   "country",      :limit => 20, :default => ""
    t.string   "phone1",       :limit => 50, :default => ""
    t.string   "fax1",         :limit => 50, :default => ""
    t.string   "old_code",     :limit => 25, :default => ""
    t.string   "first_name",   :limit => 50
    t.string   "last_name",    :limit => 50
  end

  add_index "customer_shippings", ["customer_id"], :name => "customer_shippings_customer_id"

  create_table "customer_wishlists", :force => true do |t|
    t.integer  "company_id",                                               :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,   :default => "Y"
    t.string   "trans_flag",               :limit => 1,   :default => "A"
    t.integer  "lock_version",                            :default => 0
    t.integer  "customer_id"
    t.datetime "wish_date"
    t.string   "salesperson_code",         :limit => 25
    t.string   "catalog_item_code",        :limit => 25
    t.string   "catalog_item_description", :limit => 200
    t.string   "item_for_whom",            :limit => 100
    t.string   "catalog_item_price"
    t.string   "decimal"
    t.string   "remarks",                  :limit => 200
  end

  create_table "customers", :force => true do |t|
    t.integer  "company_id",                                                              :default => 1,    :null => false
    t.integer  "created_by",                                                              :default => 0
    t.datetime "created_at"
    t.integer  "updated_by",                                                              :default => 0
    t.datetime "updated_at"
    t.string   "trans_flag",                :limit => 1,                                  :default => "A"
    t.string   "update_flag",               :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                            :default => 0
    t.string   "code",                      :limit => 25,                                                   :null => false
    t.string   "name",                      :limit => 50,                                 :default => " "
    t.string   "address1",                  :limit => 50,                                 :default => " "
    t.string   "address2",                  :limit => 50,                                 :default => " "
    t.string   "city",                      :limit => 25,                                 :default => " "
    t.string   "state",                     :limit => 25,                                 :default => " "
    t.string   "zip",                       :limit => 15,                                 :default => " "
    t.string   "country",                   :limit => 20,                                 :default => " "
    t.string   "phone1",                    :limit => 50,                                 :default => " "
    t.string   "phone2",                    :limit => 50,                                 :default => " "
    t.string   "fax1",                      :limit => 50,                                 :default => " "
    t.string   "cell_no",                   :limit => 15,                                 :default => " "
    t.string   "email",                     :limit => 200,                                :default => " "
    t.integer  "customer_category_id",                                                    :default => 0
    t.integer  "tax_id",                                                                  :default => 0
    t.decimal  "discount_per",                             :precision => 5,  :scale => 2, :default => 0.0
    t.integer  "discount_days",                            :precision => 5,  :scale => 0
    t.integer  "due_days",                                 :precision => 5,  :scale => 0
    t.string   "inv_type",                  :limit => 4
    t.text     "notes_text"
    t.string   "territory",                 :limit => 10,                                 :default => " "
    t.string   "territory2",                :limit => 10,                                 :default => " "
    t.string   "territory3",                :limit => 10,                                 :default => " "
    t.decimal  "credit_limit",                             :precision => 12, :scale => 2
    t.string   "price_level",               :limit => 1,                                  :default => "A"
    t.string   "salesperson_code",          :limit => 8
    t.string   "message_id",                :limit => 8,                                  :default => " "
    t.string   "inv_print_no",              :limit => 8,                                  :default => " "
    t.string   "shipping_code",                                                           :default => "25"
    t.string   "website",                   :limit => 150,                                :default => " "
    t.string   "email_yn",                  :limit => 1,                                  :default => "N"
    t.string   "fax_yn",                    :limit => 1,                                  :default => "N"
    t.string   "print_yn",                  :limit => 1,                                  :default => "N"
    t.string   "message_yn",                :limit => 1,                                  :default => "N"
    t.string   "paymentpriority",           :limit => 1,                                  :default => "A"
    t.string   "ten99_yn",                  :limit => 1,                                  :default => "N"
    t.string   "ein_no",                    :limit => 20,                                 :default => " "
    t.datetime "valid_dt"
    t.string   "udf1",                      :limit => 100,                                :default => " "
    t.string   "udf2",                      :limit => 100,                                :default => " "
    t.string   "udf3",                      :limit => 100,                                :default => " "
    t.string   "udf4",                      :limit => 100,                                :default => " "
    t.string   "udf5",                      :limit => 100,                                :default => " "
    t.string   "udf6",                      :limit => 100,                                :default => " "
    t.string   "dunning_yn",                :limit => 1,                                  :default => "N"
    t.decimal  "salescomm_per",                            :precision => 5,  :scale => 2, :default => 0.0
    t.decimal  "coop_per",                                 :precision => 5,  :scale => 2, :default => 0.0
    t.integer  "billto_id"
    t.decimal  "base_goldprice",                           :precision => 12, :scale => 5, :default => 0.0
    t.string   "memo_term_code",            :limit => 25,                                 :default => " "
    t.string   "invoice_term_code",         :limit => 25,                                 :default => " "
    t.string   "stop_ship",                 :limit => 1,                                  :default => "N",  :null => false
    t.string   "jbt_ranking",               :limit => 10,                                 :default => " "
    t.string   "credit_approval_flag",      :limit => 1,                                  :default => "Y"
    t.string   "blacklisted_flag",          :limit => 1,                                  :default => " "
    t.string   "bank_account_no",           :limit => 30,                                 :default => " "
    t.string   "wfca_flag",                 :limit => 1,                                  :default => "N"
    t.string   "passport_no",               :limit => 30,                                 :default => " "
    t.string   "guarantee_name",            :limit => 50,                                 :default => " "
    t.string   "contact1",                  :limit => 50,                                 :default => " "
    t.string   "contact2",                  :limit => 50,                                 :default => " "
    t.string   "contact3",                  :limit => 50,                                 :default => " "
    t.string   "contact4",                  :limit => 50,                                 :default => " "
    t.string   "contact1_phone",            :limit => 15,                                 :default => " "
    t.string   "contact2_phone",            :limit => 15,                                 :default => " "
    t.string   "inactive",                  :limit => 1,                                  :default => "N"
    t.string   "bank_name",                 :limit => 50,                                 :default => " "
    t.string   "bank_address1",             :limit => 50,                                 :default => " "
    t.string   "bank_address2",             :limit => 50,                                 :default => " "
    t.string   "bank_phone",                :limit => 50,                                 :default => " "
    t.string   "bank_fax",                  :limit => 50,                                 :default => " "
    t.string   "bank_contact_person",       :limit => 50,                                 :default => " "
    t.string   "so_partial_ship_flag",      :limit => 1,                                  :default => " "
    t.string   "so_item_partial_ship_flag", :limit => 1,                                  :default => "N"
    t.string   "collection",                :limit => 1,                                  :default => "N"
    t.decimal  "impairment_percent",                       :precision => 6,  :scale => 2, :default => 0.0
    t.string   "style_suffix",              :limit => 2,                                  :default => "AA"
    t.string   "location_code",             :limit => 25,                                 :default => "NA"
    t.string   "type1",                     :limit => 4
    t.string   "type2",                     :limit => 4
    t.integer  "postdated_checks",                         :precision => 4,  :scale => 0
    t.integer  "return_checks",                            :precision => 4,  :scale => 0
    t.integer  "gl_account1_id"
    t.integer  "gl_account2_id"
    t.integer  "gl_account3_id"
    t.integer  "gl_account4_id"
    t.string   "password",                  :limit => 20
    t.string   "login_code",                :limit => 100
    t.string   "first_name",                :limit => 50
    t.string   "last_name",                 :limit => 50
    t.string   "alternate_email_id",        :limit => 100
    t.string   "customer_type",             :limit => 1,                                  :default => "W"
    t.string   "web_access_flag",           :limit => 1,                                  :default => "N"
    t.string   "gender",                    :limit => 25
    t.string   "title",                     :limit => 25
    t.string   "suffix",                    :limit => 25
    t.string   "birth_date",                :limit => 6
    t.string   "account_type",              :limit => 25
  end

  create_table "dataupload_completes", :force => true do |t|
    t.integer  "company_id",                                        :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",       :limit => 1,   :default => "Y"
    t.string   "trans_flag",        :limit => 1,   :default => "A"
    t.integer  "lock_version",                     :default => 0
    t.datetime "request_date"
    t.string   "request_email_id",  :limit => 100,                  :null => false
    t.string   "request_file_name", :limit => 100,                  :null => false
    t.string   "server_file_path",  :limit => 200,                  :null => false
    t.string   "request_status",    :limit => 1,   :default => "N"
    t.string   "response1_flag",    :limit => 1,   :default => "N"
    t.string   "response2_flag",    :limit => 1,   :default => "N"
    t.string   "overwrite_flag",    :limit => 1,   :default => "N"
  end

  create_table "dataupload_requests", :force => true do |t|
    t.integer  "company_id",                                        :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",       :limit => 1,   :default => "Y"
    t.string   "trans_flag",        :limit => 1,   :default => "A"
    t.integer  "lock_version",                     :default => 0
    t.datetime "request_date"
    t.string   "request_email_id",  :limit => 100,                  :null => false
    t.string   "request_file_name", :limit => 100,                  :null => false
    t.string   "server_file_path",  :limit => 200,                  :null => false
    t.string   "request_status",    :limit => 1,   :default => "N"
    t.string   "response1_flag",    :limit => 1,   :default => "N"
    t.string   "response2_flag",    :limit => 1,   :default => "N"
    t.string   "overwrite_flag",    :limit => 1,   :default => "N"
  end

  create_table "diamond_categories", :force => true do |t|
    t.integer  "company_id",                 :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,  :default => "Y"
    t.string   "trans_flag",   :limit => 1,  :default => "A"
    t.integer  "lock_version",               :default => 0
    t.string   "code",         :limit => 25
    t.string   "name",         :limit => 50
  end

  create_table "diamond_inventories", :force => true do |t|
    t.integer  "company_id",                        :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,  :default => "Y"
    t.string   "trans_flag",          :limit => 1,  :default => "A"
    t.integer  "lock_version",                      :default => 0
    t.string   "trans_bk",            :limit => 4
    t.string   "trans_no",            :limit => 18
    t.string   "account_period_code", :limit => 8
    t.datetime "trans_date"
    t.string   "post_flag",           :limit => 1
    t.string   "ri_flag",             :limit => 1
    t.string   "remarks"
    t.string   "trans_type",          :limit => 1
    t.integer  "trans_type_id"
    t.string   "ext_ref_no",          :limit => 50
    t.datetime "ext_ref_date"
  end

  create_table "diamond_inventory_details", :force => true do |t|
    t.integer  "company_id",                                                        :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",          :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",           :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                      :default => 0
    t.string   "trans_bk",             :limit => 4
    t.string   "trans_no",             :limit => 18
    t.datetime "trans_date"
    t.string   "serial_no",            :limit => 6
    t.string   "trans_type",           :limit => 4
    t.integer  "diamond_lot_id"
    t.integer  "diamond_packet_id"
    t.integer  "customer_vendor_id"
    t.string   "location_code",        :limit => 25
    t.string   "stone_type",           :limit => 18
    t.string   "shape",                :limit => 18
    t.string   "color",                :limit => 18
    t.string   "clarity",              :limit => 18
    t.string   "quality",              :limit => 18
    t.decimal  "stock_rec_pcs",                      :precision => 10, :scale => 2
    t.decimal  "stock_iss_pcs",                      :precision => 10, :scale => 2
    t.decimal  "memo_rec_pcs",                       :precision => 10, :scale => 2
    t.decimal  "memo_iss_pcs",                       :precision => 10, :scale => 2
    t.decimal  "stock_rec_wt",                       :precision => 12, :scale => 3
    t.decimal  "stock_iss_wt",                       :precision => 12, :scale => 3
    t.decimal  "memo_rec_wt",                        :precision => 12, :scale => 3
    t.decimal  "memo_iss_wt",                        :precision => 12, :scale => 3
    t.decimal  "stock_rec_amt",                      :precision => 12, :scale => 2
    t.decimal  "stock_iss_amt",                      :precision => 12, :scale => 2
    t.decimal  "memo_rec_amt",                       :precision => 12, :scale => 2
    t.decimal  "memo_iss_amt",                       :precision => 12, :scale => 2
    t.decimal  "stock_rec_price",                    :precision => 10, :scale => 2
    t.decimal  "stock_iss_price",                    :precision => 10, :scale => 2
    t.decimal  "memo_rec_price",                     :precision => 10, :scale => 2
    t.decimal  "memo_iss_price",                     :precision => 10, :scale => 2
    t.decimal  "cost",                               :precision => 10, :scale => 2
    t.string   "sell_unit",            :limit => 4
    t.string   "type",                 :limit => 50
    t.string   "account_period_code",  :limit => 8
    t.string   "remarks"
    t.string   "customer_vendor_flag", :limit => 1
    t.string   "ri_flag",              :limit => 1
    t.string   "ext_ref_no",           :limit => 50
    t.datetime "ext_ref_date"
  end

  create_table "diamond_inventory_lines", :force => true do |t|
    t.integer  "company_id",                                                        :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",          :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",           :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                      :default => 0
    t.string   "trans_bk",             :limit => 4
    t.string   "trans_no",             :limit => 18
    t.datetime "trans_date"
    t.string   "serial_no",            :limit => 6
    t.integer  "diamond_lot_id"
    t.integer  "diamond_packet_id"
    t.integer  "diamond_inventory_id"
    t.string   "remarks"
    t.string   "ri_flag",              :limit => 1
    t.string   "memo_flag",            :limit => 1
    t.string   "account_period_code",  :limit => 8
    t.string   "location_code",        :limit => 25
    t.string   "stone_type",           :limit => 25
    t.string   "shape",                :limit => 25
    t.string   "color",                :limit => 25
    t.string   "clarity",              :limit => 25
    t.string   "quality",              :limit => 25
    t.decimal  "size",                               :precision => 7,  :scale => 2
    t.decimal  "iss_pcs",                            :precision => 12, :scale => 2
    t.decimal  "rec_pcs",                            :precision => 12, :scale => 2
    t.decimal  "iss_price",                          :precision => 12, :scale => 2
    t.decimal  "rec_price",                          :precision => 12, :scale => 2
    t.decimal  "iss_wt",                             :precision => 12, :scale => 3
    t.decimal  "rec_wt",                             :precision => 12, :scale => 3
    t.decimal  "iss_amt",                            :precision => 12, :scale => 2
    t.decimal  "rec_amt",                            :precision => 12, :scale => 2
    t.decimal  "wtd_cost",                           :precision => 12, :scale => 2
    t.string   "diamond_lot_no",       :limit => 25
    t.string   "diamond_packet_no",    :limit => 25
    t.string   "lot_description",      :limit => 50
    t.string   "sell_unit",            :limit => 4
  end

  add_index "diamond_inventory_lines", ["diamond_inventory_id"], :name => "idx_diamond_inventory_lines_diamond_inventory_id"

  create_table "diamond_inventory_summaries", :force => true do |t|
    t.integer  "company_id",                                                       :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                     :default => 0
    t.integer  "diamond_lot_id"
    t.integer  "diamond_packet_id"
    t.string   "location_code",       :limit => 25
    t.string   "account_period_code", :limit => 8
    t.string   "stone_type",          :limit => 18
    t.string   "shape",               :limit => 18
    t.string   "color",               :limit => 18
    t.string   "clarity",             :limit => 18
    t.string   "quality",             :limit => 18
    t.decimal  "stock_rec_pcs",                     :precision => 10, :scale => 2
    t.decimal  "stock_iss_pcs",                     :precision => 10, :scale => 2
    t.decimal  "memo_rec_pcs",                      :precision => 10, :scale => 2
    t.decimal  "memo_iss_pcs",                      :precision => 10, :scale => 2
    t.decimal  "stock_rec_wt",                      :precision => 12, :scale => 3
    t.decimal  "stock_iss_wt",                      :precision => 12, :scale => 3
    t.decimal  "memo_rec_wt",                       :precision => 12, :scale => 3
    t.decimal  "memo_iss_wt",                       :precision => 12, :scale => 3
    t.decimal  "stock_rec_amt",                     :precision => 12, :scale => 2
    t.decimal  "stock_iss_amt",                     :precision => 12, :scale => 2
    t.decimal  "memo_rec_amt",                      :precision => 12, :scale => 2
    t.decimal  "memo_iss_amt",                      :precision => 12, :scale => 2
    t.decimal  "stock_rec_price",                   :precision => 10, :scale => 2
    t.decimal  "stock_iss_price",                   :precision => 10, :scale => 2
    t.decimal  "memo_rec_price",                    :precision => 10, :scale => 2
    t.decimal  "memo_iss_price",                    :precision => 10, :scale => 2
    t.decimal  "cost",                              :precision => 10, :scale => 2
  end

  create_table "diamond_inventory_transfers", :force => true do |t|
    t.integer  "company_id",                                                                        :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                     :default => 0
    t.datetime "transfer_date"
    t.integer  "store_id_from",                                                                     :null => false
    t.integer  "store_id_to",                                                                       :null => false
    t.string   "issued_trans_bk",     :limit => 4
    t.string   "received_trans_bk",   :limit => 4
    t.string   "issued_trans_no",     :limit => 18
    t.string   "received_trans_no",   :limit => 18
    t.datetime "issued_trans_date"
    t.datetime "received_trans_date"
    t.string   "issued_serial_no",    :limit => 6
    t.string   "received_serial_no",  :limit => 6
    t.string   "account_period_code", :limit => 8
    t.integer  "diamond_lot_id",                                                                    :null => false
    t.integer  "diamond_packet_id",                                                                 :null => false
    t.decimal  "transfer_qty",                      :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "transfer_price",                    :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "transfer_amt",                      :precision => 12, :scale => 2, :default => 0.0
    t.string   "status",              :limit => 1,                                 :default => "T"
    t.string   "diamond_packet_no",   :limit => 25
    t.string   "diamond_lot_no",      :limit => 25
    t.string   "lot_description",     :limit => 50
  end

  create_table "diamond_locations", :force => true do |t|
    t.integer  "company_id",                                  :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,  :default => "Y"
    t.string   "trans_flag",   :limit => 1,  :default => "A"
    t.integer  "lock_version",               :default => 0
    t.string   "code",         :limit => 50
    t.string   "name",         :limit => 50
  end

  create_table "diamond_lots", :force => true do |t|
    t.integer  "company_id",                                                       :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                     :default => 0
    t.string   "lot_number",          :limit => 25
    t.string   "description",         :limit => 50
    t.string   "stone_type",          :limit => 18
    t.string   "shape",               :limit => 18
    t.string   "color",               :limit => 18
    t.string   "clarity",             :limit => 18
    t.string   "quality",             :limit => 18
    t.string   "setting",             :limit => 18
    t.decimal  "ct_average",                        :precision => 10, :scale => 3
    t.decimal  "ct_from",                           :precision => 10, :scale => 3
    t.decimal  "ct_to",                             :precision => 10, :scale => 3
    t.decimal  "size",                              :precision => 7,  :scale => 2
    t.decimal  "size_from",                         :precision => 7,  :scale => 2
    t.decimal  "size_to",                           :precision => 7,  :scale => 2
    t.decimal  "sieve_plate_from",                  :precision => 7,  :scale => 2
    t.decimal  "sieve_plate_to",                    :precision => 7,  :scale => 2
    t.string   "location",            :limit => 25
    t.string   "cert_flag",           :limit => 1
    t.string   "cost_unit",           :limit => 4
    t.decimal  "cost_per_pcs",                      :precision => 10, :scale => 2
    t.decimal  "cost_per_ct",                       :precision => 10, :scale => 2
    t.decimal  "price_per_pcs",                     :precision => 10, :scale => 2
    t.decimal  "price_per_ct",                      :precision => 10, :scale => 2
    t.integer  "diamond_category_id"
  end

  create_table "diamond_packet_update_lines", :force => true do |t|
    t.integer  "company_id",                                                                             :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                          :default => 0
    t.string   "trans_bk",                 :limit => 4,                                                  :null => false
    t.string   "trans_no",                 :limit => 18,                                                 :null => false
    t.datetime "trans_date",                                                                             :null => false
    t.string   "serial_no",                :limit => 6
    t.integer  "diamond_packet_update_id",                                                               :null => false
    t.integer  "diamond_lot_id"
    t.integer  "vendor_id"
    t.string   "packet_no",                :limit => 25
    t.decimal  "weight",                                 :precision => 10, :scale => 4
    t.string   "location",                 :limit => 25
    t.string   "shape",                    :limit => 18
    t.string   "color",                    :limit => 18
    t.string   "clarity",                  :limit => 18
    t.string   "barcode_no",               :limit => 18
    t.string   "fluorescence",             :limit => 15
    t.string   "polish",                   :limit => 15
    t.string   "symmetry",                 :limit => 15
    t.string   "proportion",               :limit => 15
    t.string   "cut_grade",                :limit => 15
    t.string   "fluorescence_color",       :limit => 10
    t.decimal  "depth_per",                              :precision => 6,  :scale => 2
    t.decimal  "table_per",                              :precision => 6,  :scale => 2
    t.decimal  "size",                                   :precision => 6,  :scale => 2
    t.string   "max_girdle",               :limit => 15
    t.string   "min_girdle",               :limit => 15
    t.string   "girdle",                   :limit => 15
    t.string   "culet",                    :limit => 15
    t.string   "cert_type",                :limit => 15
    t.string   "certified_yn",             :limit => 1
    t.string   "received_yn",              :limit => 1
    t.string   "web_upload1",              :limit => 1
    t.string   "web_upload2",              :limit => 1
    t.string   "web_upload3",              :limit => 1
    t.string   "certificate_no",           :limit => 20
    t.string   "laboratory",               :limit => 20
    t.string   "client_no",                :limit => 25
    t.decimal  "rapaport_price",                         :precision => 10, :scale => 2
    t.decimal  "cost",                                   :precision => 10, :scale => 2
    t.decimal  "web_discount1",                          :precision => 10, :scale => 2
    t.decimal  "web_price1",                             :precision => 10, :scale => 2
    t.decimal  "discount_per",                           :precision => 6,  :scale => 2
    t.decimal  "web_discount2",                          :precision => 10, :scale => 2
    t.decimal  "web_price2",                             :precision => 10, :scale => 2
    t.decimal  "web_discount3",                          :precision => 10, :scale => 2
    t.decimal  "web_price3",                             :precision => 10, :scale => 2
    t.string   "unit",                     :limit => 4
    t.string   "white_light",              :limit => 4
    t.string   "color_light",              :limit => 4
    t.string   "scintillation",            :limit => 4
    t.decimal  "length",                                 :precision => 5,  :scale => 2
    t.decimal  "width",                                  :precision => 5,  :scale => 2
    t.decimal  "depth",                                  :precision => 5,  :scale => 2
    t.string   "diamond_lot_no",           :limit => 25
    t.string   "diamond_packet_no",        :limit => 25
  end

  add_index "diamond_packet_update_lines", ["diamond_packet_update_id"], :name => "idx_diamond_packet_update_lines_diamond_packet_update_id"

  create_table "diamond_packet_updates", :force => true do |t|
    t.integer  "company_id",                                          :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,   :default => "Y"
    t.string   "trans_flag",          :limit => 1,   :default => "A"
    t.integer  "lock_version",                       :default => 0
    t.string   "trans_bk",            :limit => 4,                    :null => false
    t.string   "ref_trans_bk",        :limit => 4
    t.string   "trans_no",            :limit => 18,                   :null => false
    t.string   "ref_trans_no",        :limit => 18
    t.datetime "trans_date",                                          :null => false
    t.string   "account_period_code", :limit => 8,                    :null => false
    t.string   "file_name",           :limit => 100
    t.string   "remarks",             :limit => 200
  end

  create_table "diamond_packets", :force => true do |t|
    t.integer  "company_id",                                                      :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",        :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",         :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                    :default => 0
    t.integer  "diamond_lot_id"
    t.integer  "vendor_id"
    t.string   "packet_no",          :limit => 25
    t.decimal  "weight",                           :precision => 10, :scale => 4
    t.string   "location",           :limit => 25
    t.string   "shape",              :limit => 18
    t.string   "color",              :limit => 18
    t.string   "clarity",            :limit => 18
    t.string   "barcode_no",         :limit => 18
    t.string   "fluorescence",       :limit => 15
    t.string   "polish",             :limit => 15
    t.string   "symmetry",           :limit => 15
    t.string   "proportion",         :limit => 15
    t.string   "cut_grade",          :limit => 15
    t.string   "fluorescence_color", :limit => 10
    t.decimal  "depth_per",                        :precision => 6,  :scale => 2
    t.decimal  "table_per",                        :precision => 6,  :scale => 2
    t.decimal  "size",                             :precision => 6,  :scale => 2
    t.string   "max_girdle",         :limit => 15
    t.string   "min_girdle",         :limit => 15
    t.string   "girdle",             :limit => 15
    t.string   "culet",              :limit => 15
    t.string   "cert_type",          :limit => 15
    t.string   "certified_yn",       :limit => 1
    t.string   "received_yn",        :limit => 1
    t.string   "web_upload1",        :limit => 1
    t.string   "web_upload2",        :limit => 1
    t.string   "web_upload3",        :limit => 1
    t.string   "certificate_no",     :limit => 20
    t.string   "laboratory",         :limit => 20
    t.string   "client_no",          :limit => 25
    t.decimal  "rapaport_price",                   :precision => 10, :scale => 2
    t.decimal  "cost",                             :precision => 10, :scale => 2
    t.decimal  "web_discount1",                    :precision => 10, :scale => 2
    t.decimal  "web_price1",                       :precision => 10, :scale => 2
    t.decimal  "discount_per",                     :precision => 6,  :scale => 2
    t.decimal  "web_discount2",                    :precision => 10, :scale => 2
    t.decimal  "web_price2",                       :precision => 10, :scale => 2
    t.decimal  "web_discount3",                    :precision => 10, :scale => 2
    t.decimal  "web_price3",                       :precision => 10, :scale => 2
    t.string   "unit",               :limit => 4
    t.string   "white_light",        :limit => 4
    t.string   "color_light",        :limit => 4
    t.string   "scintillation",      :limit => 4
    t.decimal  "length",                           :precision => 5,  :scale => 2
    t.decimal  "width",                            :precision => 5,  :scale => 2
    t.decimal  "depth",                            :precision => 5,  :scale => 2
  end

  add_index "diamond_packets", ["diamond_lot_id"], :name => "diamond_packets_diamond_lot_id"

  create_table "diamond_purchase_lines", :force => true do |t|
    t.integer  "company_id",                                                       :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                     :default => 0
    t.string   "trans_bk",            :limit => 4
    t.string   "ref_trans_bk",        :limit => 4
    t.string   "trans_no",            :limit => 18
    t.string   "ref_trans_no",        :limit => 18
    t.datetime "trans_date"
    t.datetime "ref_trans_date"
    t.string   "serial_no",           :limit => 6
    t.string   "ref_serial_no",       :limit => 6
    t.string   "ref_type",            :limit => 1
    t.integer  "diamond_lot_id"
    t.integer  "diamond_packet_id"
    t.integer  "diamond_purchase_id"
    t.string   "location_code",       :limit => 25
    t.string   "stone_type",          :limit => 18
    t.string   "shape",               :limit => 18
    t.string   "color",               :limit => 18
    t.string   "clarity",             :limit => 18
    t.string   "quality",             :limit => 18
    t.decimal  "commission_per",                    :precision => 6,  :scale => 2
    t.decimal  "discount_per",                      :precision => 6,  :scale => 2
    t.decimal  "size",                              :precision => 6,  :scale => 2
    t.decimal  "pcs",                               :precision => 10, :scale => 2
    t.decimal  "ref_pcs",                           :precision => 10, :scale => 2
    t.decimal  "clear_pcs",                         :precision => 10, :scale => 2
    t.decimal  "wt",                                :precision => 12, :scale => 3
    t.decimal  "ref_wt",                            :precision => 12, :scale => 3
    t.decimal  "clear_wt",                          :precision => 12, :scale => 3
    t.decimal  "net_amt",                           :precision => 12, :scale => 2
    t.decimal  "discount_amt",                      :precision => 12, :scale => 2
    t.decimal  "line_amt",                          :precision => 12, :scale => 2
    t.decimal  "commission_amt",                    :precision => 12, :scale => 2
    t.decimal  "price",                             :precision => 10, :scale => 2
    t.decimal  "cost",                              :precision => 10, :scale => 2
    t.string   "sell_unit",           :limit => 4
    t.string   "type",                :limit => 50
    t.string   "account_period_code", :limit => 8
    t.string   "diamond_lot_number",  :limit => 25
    t.string   "diamond_packet_code", :limit => 25
  end

  add_index "diamond_purchase_lines", ["diamond_purchase_id"], :name => "idx_diamond_purchase_lines_diamond_purchase_id"

  create_table "diamond_purchases", :force => true do |t|
    t.integer  "company_id",                                                       :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                     :default => 0
    t.string   "trans_bk",            :limit => 4
    t.string   "trans_no",            :limit => 18
    t.datetime "trans_date"
    t.integer  "vendor_id"
    t.integer  "company_store_id"
    t.string   "account_period_code", :limit => 8
    t.string   "shipping_code",       :limit => 25
    t.string   "term_code",           :limit => 25
    t.string   "purchaseperson_code", :limit => 25
    t.string   "ref_trans_no",        :limit => 18
    t.string   "trans_type",          :limit => 1
    t.string   "post_flag",           :limit => 1
    t.string   "ref_type",            :limit => 1
    t.decimal  "ship_per",                          :precision => 6,  :scale => 2
    t.decimal  "insurance_per",                     :precision => 6,  :scale => 2
    t.decimal  "tax_per",                           :precision => 6,  :scale => 2
    t.decimal  "discount_per",                      :precision => 6,  :scale => 2
    t.decimal  "ship_amt",                          :precision => 12, :scale => 2
    t.decimal  "insurance_amt",                     :precision => 12, :scale => 2
    t.decimal  "tax_amt",                           :precision => 12, :scale => 2
    t.decimal  "discount_amt",                      :precision => 12, :scale => 2
    t.decimal  "lines_amt",                         :precision => 12, :scale => 2
    t.decimal  "other_amt",                         :precision => 12, :scale => 2
    t.decimal  "commission_amt",                    :precision => 12, :scale => 2
    t.decimal  "net_amt",                           :precision => 12, :scale => 2
    t.decimal  "commission_per",                    :precision => 6,  :scale => 2
    t.string   "ref_trans_bk",        :limit => 4
    t.string   "remarks"
    t.string   "tracking_no",         :limit => 50
    t.string   "po_no",               :limit => 50
    t.string   "ship_name",           :limit => 50
    t.string   "bill_name",           :limit => 50
    t.datetime "ref_trans_dt"
    t.datetime "po_date"
    t.datetime "ship_date"
    t.datetime "cancel_date"
    t.datetime "due_date"
    t.string   "ship_address1",       :limit => 50
    t.string   "ship_address2",       :limit => 50
    t.string   "bill_address1",       :limit => 50
    t.string   "bill_address2",       :limit => 50
    t.string   "ship_city",           :limit => 25
    t.string   "ship_state",          :limit => 25
    t.string   "bill_city",           :limit => 25
    t.string   "bill_state",          :limit => 25
    t.string   "ship_zip",            :limit => 15
    t.string   "bill_zip",            :limit => 15
    t.string   "ship_country",        :limit => 20
    t.string   "bill_country",        :limit => 20
    t.string   "ship_phone",          :limit => 50
    t.string   "ship_fax",            :limit => 50
    t.string   "bill_phone",          :limit => 50
    t.string   "bill_fax",            :limit => 50
    t.decimal  "total_pcs",                         :precision => 12, :scale => 2
    t.decimal  "total_wt",                          :precision => 12, :scale => 3
    t.string   "type",                :limit => 50
  end

  add_index "diamond_purchases", ["vendor_id"], :name => "diamond_purchases_vendor_id"

  create_table "diamond_sale_lines", :force => true do |t|
    t.integer  "company_id",                                                       :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                     :default => 0
    t.string   "trans_bk",            :limit => 4
    t.string   "ref_trans_bk",        :limit => 4
    t.string   "trans_no",            :limit => 18
    t.string   "ref_trans_no",        :limit => 18
    t.datetime "trans_date"
    t.datetime "ref_trans_date"
    t.string   "serial_no",           :limit => 6
    t.string   "ref_serial_no",       :limit => 6
    t.string   "ref_type",            :limit => 1
    t.integer  "diamond_lot_id"
    t.integer  "diamond_packet_id"
    t.integer  "diamond_sale_id"
    t.string   "location_code",       :limit => 25
    t.string   "stone_type",          :limit => 18
    t.string   "shape",               :limit => 18
    t.string   "color",               :limit => 18
    t.string   "clarity",             :limit => 18
    t.string   "quality",             :limit => 18
    t.decimal  "commission_per",                    :precision => 6,  :scale => 2
    t.decimal  "discount_per",                      :precision => 6,  :scale => 2
    t.decimal  "size",                              :precision => 6,  :scale => 2
    t.decimal  "pcs",                               :precision => 10, :scale => 2
    t.decimal  "ref_pcs",                           :precision => 10, :scale => 2
    t.decimal  "clear_pcs",                         :precision => 10, :scale => 2
    t.decimal  "wt",                                :precision => 12, :scale => 3
    t.decimal  "ref_wt",                            :precision => 12, :scale => 3
    t.decimal  "clear_wt",                          :precision => 12, :scale => 3
    t.decimal  "net_amt",                           :precision => 12, :scale => 2
    t.decimal  "discount_amt",                      :precision => 12, :scale => 2
    t.decimal  "line_amt",                          :precision => 12, :scale => 2
    t.decimal  "commission_amt",                    :precision => 12, :scale => 2
    t.decimal  "price",                             :precision => 10, :scale => 2
    t.decimal  "cost",                              :precision => 10, :scale => 2
    t.string   "sell_unit",           :limit => 4
    t.string   "type",                :limit => 50
    t.string   "account_period_code", :limit => 8
    t.string   "diamond_lot_number",  :limit => 25
    t.string   "diamond_packet_code", :limit => 25
  end

  add_index "diamond_sale_lines", ["diamond_sale_id"], :name => "idx_diamond_sale_lines_diamond_sale_id"

  create_table "diamond_sales", :force => true do |t|
    t.integer  "company_id",                                                        :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",          :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",           :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                      :default => 0
    t.string   "trans_bk",             :limit => 4
    t.string   "trans_no",             :limit => 18
    t.datetime "trans_date"
    t.integer  "customer_id"
    t.integer  "customer_shipping_id"
    t.string   "account_period_code",  :limit => 8
    t.string   "shipping_code",        :limit => 25
    t.string   "term_code",            :limit => 25
    t.string   "salesperson_code",     :limit => 25
    t.string   "ref_trans_no",         :limit => 18
    t.string   "trans_type",           :limit => 1
    t.string   "post_flag",            :limit => 1
    t.string   "ref_type",             :limit => 1
    t.decimal  "ship_per",                           :precision => 6,  :scale => 2
    t.decimal  "insurance_per",                      :precision => 6,  :scale => 2
    t.decimal  "tax_per",                            :precision => 6,  :scale => 2
    t.decimal  "discount_per",                       :precision => 6,  :scale => 2
    t.decimal  "ship_amt",                           :precision => 12, :scale => 2
    t.decimal  "insurance_amt",                      :precision => 12, :scale => 2
    t.decimal  "tax_amt",                            :precision => 12, :scale => 2
    t.decimal  "discount_amt",                       :precision => 12, :scale => 2
    t.decimal  "lines_amt",                          :precision => 12, :scale => 2
    t.decimal  "other_amt",                          :precision => 12, :scale => 2
    t.decimal  "commission_amt",                     :precision => 12, :scale => 2
    t.decimal  "net_amt",                            :precision => 12, :scale => 2
    t.decimal  "commission_per",                     :precision => 6,  :scale => 2
    t.string   "ref_trans_bk",         :limit => 4
    t.string   "remarks"
    t.string   "tracking_no",          :limit => 50
    t.string   "po_no",                :limit => 50
    t.string   "ship_name",            :limit => 50
    t.string   "bill_name",            :limit => 50
    t.datetime "ref_trans_dt"
    t.datetime "po_date"
    t.datetime "ship_date"
    t.datetime "cancel_date"
    t.datetime "due_date"
    t.string   "ship_address1",        :limit => 50
    t.string   "ship_address2",        :limit => 50
    t.string   "bill_address1",        :limit => 50
    t.string   "bill_address2",        :limit => 50
    t.string   "ship_city",            :limit => 25
    t.string   "ship_state",           :limit => 25
    t.string   "bill_city",            :limit => 25
    t.string   "bill_state",           :limit => 25
    t.string   "ship_zip",             :limit => 15
    t.string   "bill_zip",             :limit => 15
    t.string   "ship_country",         :limit => 20
    t.string   "bill_country",         :limit => 20
    t.string   "ship_phone",           :limit => 50
    t.string   "ship_fax",             :limit => 50
    t.string   "bill_phone",           :limit => 50
    t.string   "bill_fax",             :limit => 50
    t.decimal  "total_pcs",                          :precision => 12, :scale => 2
    t.decimal  "total_wt",                           :precision => 12, :scale => 3
    t.string   "type",                 :limit => 50
  end

  add_index "diamond_sales", ["customer_id"], :name => "diamond_sales_customer_id"

  create_table "documents", :force => true do |t|
    t.integer  "company_id",                   :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",   :limit => 1,   :default => "Y"
    t.string   "trans_flag",    :limit => 1,   :default => "A"
    t.integer  "lock_version",                 :default => 0
    t.string   "code",          :limit => 25,                   :null => false
    t.string   "document_name", :limit => 100
    t.string   "component_cd",  :limit => 100
  end

  create_table "email_configs", :force => true do |t|
    t.integer  "company_id",                   :default => 1,      :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",   :limit => 1,   :default => "Y"
    t.string   "trans_flag",    :limit => 1,   :default => "A"
    t.integer  "lock_version",                 :default => 0
    t.string   "event_type",    :limit => 4,   :default => "AUTO"
    t.string   "trigger_event", :limit => 50,                      :null => false
    t.string   "subject",       :limit => 100
    t.string   "email_to",      :limit => 500
    t.string   "email_cc",      :limit => 500
    t.string   "email_bcc",     :limit => 500
    t.string   "email_from",    :limit => 50
  end

  create_table "email_sends", :force => true do |t|
    t.integer  "company_id",                     :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",     :limit => 1,   :default => "Y"
    t.string   "trans_flag",      :limit => 1,   :default => "A"
    t.integer  "lock_version",                   :default => 0
    t.integer  "email_config_id",                                 :null => false
    t.string   "subject",         :limit => 100
    t.string   "email_to",        :limit => 500
    t.string   "email_cc",        :limit => 500
    t.string   "email_bcc",       :limit => 500
    t.string   "email_from",      :limit => 50
    t.string   "header"
    t.text     "body"
    t.datetime "sent_on"
    t.integer  "attempts"
  end

  create_table "emails", :force => true do |t|
    t.integer  "company_id",                     :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",     :limit => 1,   :default => "Y"
    t.string   "trans_flag",      :limit => 1,   :default => "A"
    t.integer  "lock_version",                   :default => 0
    t.integer  "email_config_id",                                 :null => false
    t.string   "subject",         :limit => 100
    t.string   "email_to",        :limit => 500
    t.string   "email_cc",        :limit => 500
    t.string   "email_bcc",       :limit => 500
    t.string   "email_from",      :limit => 50
    t.string   "header"
    t.text     "body"
    t.datetime "sent_on"
    t.integer  "attempts"
  end

  create_table "enquiries", :force => true do |t|
    t.integer  "company_id",                       :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",      :limit => 1,    :default => "Y"
    t.string   "trans_flag",       :limit => 1,    :default => "A"
    t.integer  "lock_version",                     :default => 0
    t.string   "fname",            :limit => 50,   :default => " "
    t.string   "lname",            :limit => 50,   :default => " "
    t.string   "address1",         :limit => 40,   :default => " "
    t.string   "address2",         :limit => 40,   :default => " "
    t.string   "city",             :limit => 20,   :default => " "
    t.string   "state",            :limit => 5,    :default => " "
    t.string   "zip",              :limit => 15,   :default => " "
    t.string   "country",          :limit => 20,   :default => " "
    t.string   "phone",            :limit => 15,   :default => " "
    t.string   "email",            :limit => 100,  :default => " "
    t.string   "subject",          :limit => 50,   :default => " "
    t.string   "comments",         :limit => 1000, :default => " "
    t.string   "status",           :limit => 1000, :default => "N"
    t.string   "complete_flag",    :limit => 10
    t.string   "item_description", :limit => 100
    t.string   "title",            :limit => 100
  end

  create_table "gl_accounts", :force => true do |t|
    t.integer  "company_id",                   :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",    :limit => 1,  :default => "Y"
    t.string   "trans_flag",     :limit => 1,  :default => "A"
    t.integer  "lock_version",                 :default => 0
    t.string   "code",           :limit => 25
    t.string   "group1",         :limit => 25
    t.string   "group2",         :limit => 25
    t.string   "group3",         :limit => 25
    t.string   "group4",         :limit => 25
    t.string   "name",           :limit => 50
    t.string   "balance_type",   :limit => 2
    t.integer  "gl_category_id"
    t.integer  "bank_id"
    t.datetime "start_date"
    t.string   "acct_flag",      :limit => 1
    t.integer  "tb_seq_no"
  end

  create_table "gl_categories", :force => true do |t|
    t.integer  "company_id",                 :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,  :default => "Y"
    t.string   "trans_flag",   :limit => 1,  :default => "A"
    t.integer  "lock_version",               :default => 0
    t.string   "code",         :limit => 25
    t.string   "name",         :limit => 50
    t.string   "account_type", :limit => 2
    t.integer  "tb_seq_no"
  end

  create_table "gl_details", :force => true do |t|
    t.integer  "company_id",                                                        :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",          :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",           :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                      :default => 0
    t.string   "trans_bk",             :limit => 4
    t.string   "ref_bk",               :limit => 4
    t.string   "trans_no",             :limit => 18
    t.datetime "trans_date"
    t.datetime "ref_date"
    t.string   "account_period_code",  :limit => 8
    t.string   "dtl_serial_no",        :limit => 6
    t.integer  "gl_account_id"
    t.decimal  "debit_amt",                          :precision => 12, :scale => 2
    t.decimal  "credit_amt",                         :precision => 12, :scale => 2
    t.string   "description",          :limit => 50
    t.string   "trans_type",           :limit => 4
    t.string   "ref_no",               :limit => 15
    t.string   "post_flag",            :limit => 1
    t.integer  "customer_vendor_id"
    t.string   "hdr_serial_no",        :limit => 6
    t.string   "module_code",          :limit => 6
    t.string   "customer_vendor_flag", :limit => 1
  end

  create_table "gl_setup_items", :force => true do |t|
    t.integer  "company_id",                       :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1, :default => "Y"
    t.string   "trans_flag",          :limit => 1, :default => "A"
    t.integer  "lock_version",                     :default => 0
    t.integer  "gl_setup_id",                                       :null => false
    t.string   "item_type",           :limit => 1,                  :null => false
    t.integer  "sales_account_id",                                  :null => false
    t.integer  "purchase_account_id",                               :null => false
  end

  create_table "gl_setups", :force => true do |t|
    t.integer  "company_id",                                 :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",                   :limit => 1, :default => "Y"
    t.string   "trans_flag",                    :limit => 1, :default => "A"
    t.integer  "lock_version",                               :default => 0
    t.integer  "ar_account_id",                                               :null => false
    t.integer  "ap_account_id",                                               :null => false
    t.integer  "shipping_purchase_account_id",                                :null => false
    t.integer  "shipping_sales_account_id",                                   :null => false
    t.integer  "discount_purchase_account_id",                                :null => false
    t.integer  "discount_sales_account_id",                                   :null => false
    t.integer  "salestax_purchase_account_id",                                :null => false
    t.integer  "salestax_sales_account_id",                                   :null => false
    t.integer  "default_purchase_account_id",                                 :null => false
    t.integer  "default_sales_account_id",                                    :null => false
    t.integer  "insurance_purchase_account_id"
    t.integer  "insurance_sales_account_id"
    t.integer  "faar_invoice_gl_account_id"
    t.integer  "faar_bank_id"
    t.integer  "faar_credit_gl_account_id"
    t.integer  "faap_credit_gl_account_id"
    t.integer  "faap_bank_id"
  end

  create_table "gl_summaries", :force => true do |t|
    t.integer  "company_id",                                                      :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                :default => "A"
    t.integer  "lock_version",                                                    :default => 0
    t.string   "account_period_code", :limit => 8
    t.integer  "gl_account_id"
    t.decimal  "debit_amt",                        :precision => 12, :scale => 2
    t.decimal  "credit_amt",                       :precision => 12, :scale => 2
  end

  create_table "gl_transaction_lines", :force => true do |t|
    t.integer  "company_id",                                                     :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",       :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",        :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                   :default => 0
    t.string   "trans_bk",          :limit => 4
    t.string   "trans_no",          :limit => 18
    t.string   "ref_no",            :limit => 18
    t.datetime "trans_date"
    t.datetime "ref_date"
    t.string   "serial_no",         :limit => 6
    t.integer  "gl_account_id"
    t.integer  "gl_transaction_id"
    t.decimal  "debit_amt",                       :precision => 12, :scale => 2
    t.decimal  "credit_amt",                      :precision => 12, :scale => 2
    t.string   "description",       :limit => 50
    t.string   "post_flag",         :limit => 1
  end

  add_index "gl_transaction_lines", ["gl_transaction_id"], :name => "idx_gl_transaction_lines_gl_transaction_id"

  create_table "gl_transactions", :force => true do |t|
    t.integer  "company_id",                        :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,  :default => "Y"
    t.string   "trans_flag",          :limit => 1,  :default => "A"
    t.integer  "lock_version",                      :default => 0
    t.string   "trans_bk",            :limit => 4
    t.string   "trans_no",            :limit => 18
    t.datetime "trans_date"
    t.string   "account_period_code", :limit => 8
    t.string   "trans_type",          :limit => 4
    t.string   "post_flag",           :limit => 1
  end

  create_table "gold_unit_conversions", :force => true do |t|
    t.integer  "company_id",                                                                 :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",   :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                              :default => 0
    t.string   "type",         :limit => 4
    t.string   "from_unit",    :limit => 4
    t.string   "to_unit",      :limit => 4
    t.decimal  "factor",                     :precision => 10, :scale => 5
    t.string   "caster_id",    :limit => 18
    t.string   "serial_no",    :limit => 4
    t.string   "description",  :limit => 30
  end

  create_table "inventory_details", :force => true do |t|
    t.integer  "company_id",                                                          :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",            :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",             :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                        :default => 0
    t.string   "trans_bk",               :limit => 4
    t.string   "trans_no",               :limit => 18
    t.datetime "trans_date"
    t.string   "serial_no",              :limit => 6
    t.integer  "catalog_item_id",                                                                      :null => false
    t.decimal  "stock_rec_qty",                        :precision => 10, :scale => 2
    t.decimal  "stock_iss_qty",                        :precision => 10, :scale => 2
    t.decimal  "memo_rec_qty",                         :precision => 10, :scale => 2
    t.decimal  "memo_iss_qty",                         :precision => 10, :scale => 2
    t.decimal  "stock_rec_price",                      :precision => 12, :scale => 2
    t.decimal  "stock_iss_price",                      :precision => 12, :scale => 2
    t.decimal  "memo_rec_price",                       :precision => 12, :scale => 2
    t.decimal  "memo_iss_price",                       :precision => 12, :scale => 2
    t.decimal  "stock_rec_amt",                        :precision => 12, :scale => 2
    t.decimal  "stock_iss_amt",                        :precision => 12, :scale => 2
    t.decimal  "memo_rec_amt",                         :precision => 12, :scale => 2
    t.decimal  "memo_iss_amt",                         :precision => 12, :scale => 2
    t.string   "account_period_code",    :limit => 8
    t.integer  "catalog_item_packet_id"
    t.string   "trans_type",             :limit => 1
    t.integer  "trans_type_id"
    t.string   "ext_ref_no",             :limit => 50
    t.datetime "ext_ref_date"
    t.string   "receipt_issue_flag",     :limit => 1
  end

  add_index "inventory_details", ["company_id", "catalog_item_id"], :name => "inventory_details_company_id_catalog_item_id"

  create_table "inventory_summaries", :force => true do |t|
    t.integer  "company_id",                                                         :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",            :limit => 1,                                :default => "Y"
    t.string   "trans_flag",             :limit => 1,                                :default => "A"
    t.integer  "lock_version",                                                       :default => 0
    t.integer  "catalog_item_id",                                                                     :null => false
    t.decimal  "stock_rec_qty",                       :precision => 10, :scale => 2
    t.decimal  "stock_iss_qty",                       :precision => 10, :scale => 2
    t.decimal  "memo_rec_qty",                        :precision => 10, :scale => 2
    t.decimal  "memo_iss_qty",                        :precision => 10, :scale => 2
    t.decimal  "stock_rec_amt",                       :precision => 12, :scale => 2
    t.decimal  "stock_iss_amt",                       :precision => 12, :scale => 2
    t.decimal  "memo_rec_amt",                        :precision => 12, :scale => 2
    t.decimal  "memo_iss_amt",                        :precision => 12, :scale => 2
    t.string   "account_period_code",    :limit => 8
    t.integer  "catalog_item_packet_id"
  end

  add_index "inventory_summaries", ["company_id", "catalog_item_id"], :name => "inventory_summaries_company_id_catalog_item_id"

  create_table "inventory_transaction_lines", :force => true do |t|
    t.integer  "company_id",                                                             :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                           :default => 0
    t.string   "trans_bk",                 :limit => 4
    t.string   "trans_no",                 :limit => 18
    t.datetime "trans_date"
    t.string   "serial_no",                :limit => 6
    t.string   "account_period_code",      :limit => 8
    t.string   "receipt_issue_flag",       :limit => 1
    t.string   "item_type",                :limit => 1
    t.integer  "catalog_item_id",                                                                         :null => false
    t.string   "catalog_item_code",        :limit => 25,                                                  :null => false
    t.decimal  "rec_qty",                                 :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "iss_qty",                                 :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "rec_price",                               :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "rec_amt",                                 :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "iss_price",                               :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "iss_amt",                                 :precision => 12, :scale => 2, :default => 0.0
    t.integer  "inventory_transaction_id"
    t.integer  "catalog_item_packet_id"
    t.string   "catalog_item_packet_code", :limit => 25
    t.string   "item_description",         :limit => 100
  end

  add_index "inventory_transaction_lines", ["inventory_transaction_id"], :name => "idx_inventory_transaction_lines_inventory_transaction_id"

  create_table "inventory_transactions", :force => true do |t|
    t.integer  "company_id",                        :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,  :default => "Y"
    t.string   "trans_flag",          :limit => 1,  :default => "A"
    t.integer  "lock_version",                      :default => 0
    t.string   "trans_bk",            :limit => 4
    t.string   "trans_no",            :limit => 18
    t.datetime "trans_date"
    t.string   "account_period_code", :limit => 8
    t.string   "receipt_issue_flag",  :limit => 1
    t.string   "trans_type",          :limit => 1
    t.integer  "trans_type_id"
    t.string   "ext_ref_no",          :limit => 50
    t.datetime "ext_ref_date"
    t.string   "remarks",             :limit => 50
  end

  create_table "inventory_transfers", :force => true do |t|
    t.integer  "company_id",                                                                              :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                           :default => 0
    t.datetime "transfer_date"
    t.integer  "store_id_from",                                                                           :null => false
    t.integer  "store_id_to",                                                                             :null => false
    t.string   "issued_trans_bk",          :limit => 4
    t.string   "received_trans_bk",        :limit => 4
    t.string   "issued_trans_no",          :limit => 18
    t.string   "received_trans_no",        :limit => 18
    t.datetime "issued_trans_date"
    t.datetime "received_trans_date"
    t.string   "issued_serial_no",         :limit => 6
    t.string   "received_serial_no",       :limit => 6
    t.string   "account_period_code",      :limit => 8
    t.integer  "catalog_item_id",                                                                         :null => false
    t.string   "catalog_item_code",        :limit => 25,                                                  :null => false
    t.decimal  "transfer_qty",                            :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "transfer_price",                          :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "transfer_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.string   "status",                   :limit => 1,                                  :default => "T"
    t.integer  "catalog_item_packet_id"
    t.string   "catalog_item_packet_code", :limit => 25
    t.string   "item_description",         :limit => 100
  end

  create_table "jewelry_unit_conversions", :force => true do |t|
    t.integer  "company_id",                                                                 :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",   :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                              :default => 0
    t.string   "item",         :limit => 6
    t.string   "from_unit",    :limit => 4
    t.string   "to_unit",      :limit => 4
    t.decimal  "factor",                     :precision => 13, :scale => 6
    t.string   "description",  :limit => 40
    t.string   "metal_type",   :limit => 4
  end

  create_table "lab_memo_lines", :force => true do |t|
    t.integer  "company_id",                                                                              :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                           :default => 0
    t.integer  "lab_memo_id",                                                                             :null => false
    t.string   "trans_bk",                 :limit => 4
    t.string   "ref_trans_bk",             :limit => 4
    t.string   "trans_no",                 :limit => 18
    t.string   "ref_trans_no",             :limit => 18
    t.datetime "trans_date"
    t.datetime "ref_trans_date"
    t.string   "account_period_code",      :limit => 8
    t.string   "serial_no",                :limit => 6
    t.string   "ref_serial_no",            :limit => 6
    t.string   "item_type",                :limit => 1
    t.string   "ref_type",                 :limit => 1
    t.integer  "catalog_item_id",                                                                         :null => false
    t.string   "catalog_item_code",        :limit => 25,                                                  :null => false
    t.string   "item_description",         :limit => 100,                                                 :null => false
    t.decimal  "discount_per",                            :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "item_qty",                                :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "ref_qty",                                 :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                               :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "item_price",                              :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "item_amt",                                :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                                 :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.integer  "catalog_item_packet_id"
    t.string   "catalog_item_packet_code", :limit => 25
    t.string   "lab_sku_no",               :limit => 25
  end

  create_table "lab_memo_return_lines", :force => true do |t|
    t.integer  "company_id",                                                                              :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                           :default => 0
    t.integer  "lab_memo_return_id",                                                                      :null => false
    t.string   "trans_bk",                 :limit => 4
    t.string   "ref_trans_bk",             :limit => 4
    t.string   "trans_no",                 :limit => 18
    t.string   "ref_trans_no",             :limit => 18
    t.datetime "trans_date"
    t.datetime "ref_trans_date"
    t.string   "account_period_code",      :limit => 8
    t.string   "serial_no",                :limit => 6
    t.string   "ref_serial_no",            :limit => 6
    t.string   "item_type",                :limit => 1
    t.string   "ref_type",                 :limit => 1
    t.integer  "catalog_item_id",                                                                         :null => false
    t.string   "catalog_item_code",        :limit => 25,                                                  :null => false
    t.string   "item_description",         :limit => 100,                                                 :null => false
    t.decimal  "discount_per",                            :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "item_qty",                                :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "ref_qty",                                 :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                               :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "item_price",                              :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "item_amt",                                :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                                 :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.integer  "catalog_item_packet_id"
    t.string   "catalog_item_packet_code", :limit => 25
    t.string   "lab_sku_no",               :limit => 25
  end

  create_table "lab_memo_returns", :force => true do |t|
    t.integer  "company_id",                                                                         :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",          :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",           :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                      :default => 0
    t.string   "trans_bk",             :limit => 4,                                                  :null => false
    t.string   "ref_trans_bk",         :limit => 4,                                                  :null => false
    t.string   "trans_no",             :limit => 18,                                                 :null => false
    t.string   "ref_trans_no",         :limit => 18,                                                 :null => false
    t.datetime "trans_date",                                                                         :null => false
    t.integer  "lab_id",                                                                             :null => false
    t.string   "account_period_code",  :limit => 8,                                                  :null => false
    t.datetime "sales_date"
    t.string   "term_code",            :limit => 25
    t.string   "shipping_code",        :limit => 25
    t.datetime "cancel_date"
    t.datetime "due_date"
    t.datetime "ship_date"
    t.datetime "ref_trans_date"
    t.string   "trans_type",           :limit => 1
    t.string   "ref_type",             :limit => 1
    t.string   "post_flag",            :limit => 1,                                 :default => "U"
    t.decimal  "item_qty",                           :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                          :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "discount_per",                       :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "tax_per",                            :precision => 6,  :scale => 3, :default => 0.0
    t.decimal  "item_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "tax_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                       :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.string   "remarks"
    t.string   "tracking_no",          :limit => 50
    t.string   "ship_name",            :limit => 50
    t.string   "ship_address1",        :limit => 50
    t.string   "ship_address2",        :limit => 50
    t.string   "bill_name",            :limit => 50
    t.string   "bill_address1",        :limit => 50
    t.string   "bill_address2",        :limit => 50
    t.string   "ship_city",            :limit => 25
    t.string   "ship_state",           :limit => 25
    t.string   "bill_city",            :limit => 25
    t.string   "bill_state",           :limit => 25
    t.string   "ship_zip",             :limit => 15
    t.string   "bill_zip",             :limit => 15
    t.string   "ship_country",         :limit => 20
    t.string   "bill_country",         :limit => 20
    t.string   "ship_phone",           :limit => 50
    t.string   "ship_fax",             :limit => 50
    t.string   "bill_phone",           :limit => 50
    t.string   "bill_fax",             :limit => 50
    t.integer  "customer_shipping_id"
    t.integer  "lab_shipping_id"
    t.string   "ext_ref_no",           :limit => 50
    t.datetime "ext_ref_date"
    t.decimal  "other_amt",                          :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "ship_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.string   "salesperson_code",     :limit => 25
  end

  create_table "lab_memos", :force => true do |t|
    t.integer  "company_id",                                                                        :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                     :default => 0
    t.string   "trans_bk",            :limit => 4,                                                  :null => false
    t.string   "ref_trans_bk",        :limit => 4
    t.string   "trans_no",            :limit => 18,                                                 :null => false
    t.string   "ref_trans_no",        :limit => 18
    t.datetime "trans_date",                                                                        :null => false
    t.integer  "lab_id",                                                                            :null => false
    t.string   "account_period_code", :limit => 8,                                                  :null => false
    t.datetime "memo_date"
    t.string   "term_code",           :limit => 25
    t.string   "shipping_code",       :limit => 25
    t.datetime "cancel_date"
    t.datetime "due_date"
    t.datetime "ship_date"
    t.datetime "ref_trans_date"
    t.string   "trans_type",          :limit => 1
    t.string   "ref_type",            :limit => 1
    t.string   "post_flag",           :limit => 1,                                 :default => "U"
    t.decimal  "item_qty",                          :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                         :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "discount_per",                      :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "tax_per",                           :precision => 6,  :scale => 3, :default => 0.0
    t.decimal  "item_amt",                          :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "tax_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                      :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.string   "remarks"
    t.string   "tracking_no",         :limit => 50
    t.string   "ship_name",           :limit => 50
    t.string   "ship_address1",       :limit => 50
    t.string   "ship_address2",       :limit => 50
    t.string   "bill_name",           :limit => 50
    t.string   "bill_address1",       :limit => 50
    t.string   "bill_address2",       :limit => 50
    t.string   "ship_city",           :limit => 25
    t.string   "ship_state",          :limit => 25
    t.string   "bill_city",           :limit => 25
    t.string   "bill_state",          :limit => 25
    t.string   "ship_zip",            :limit => 15
    t.string   "bill_zip",            :limit => 15
    t.string   "ship_country",        :limit => 20
    t.string   "bill_country",        :limit => 20
    t.string   "ship_phone",          :limit => 50
    t.string   "ship_fax",            :limit => 50
    t.string   "bill_phone",          :limit => 50
    t.string   "bill_fax",            :limit => 50
    t.integer  "lab_shipping_id"
    t.string   "ext_ref_no",          :limit => 50
    t.datetime "ext_ref_date"
    t.decimal  "other_amt",                         :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "ship_amt",                          :precision => 12, :scale => 2, :default => 0.0
    t.string   "salesperson_code",    :limit => 25
  end

  create_table "labors", :force => true do |t|
    t.integer  "company_id",                                                                 :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",   :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                              :default => 0
    t.string   "labor_type",   :limit => 25
    t.string   "code",         :limit => 25
    t.string   "description",  :limit => 50
    t.decimal  "cost",                       :precision => 10, :scale => 2
    t.decimal  "price",                      :precision => 12, :scale => 2
    t.decimal  "qty",                        :precision => 10, :scale => 2
    t.string   "remarks"
  end

  create_table "lead_notes", :force => true do |t|
    t.integer  "company_id",                                    :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,    :default => "Y"
    t.string   "trans_flag",   :limit => 1,    :default => "A"
    t.integer  "lock_version",                 :default => 0
    t.integer  "crm_lead_id"
    t.string   "user_cd",      :limit => 250
    t.datetime "note_date"
    t.string   "note",         :limit => 1000
    t.string   "serial_no",    :limit => 6
  end

  create_table "locations", :force => true do |t|
    t.integer  "company_id",                 :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,  :default => "Y"
    t.string   "trans_flag",   :limit => 1,  :default => "A"
    t.integer  "lock_version",               :default => 0
    t.string   "code",         :limit => 25,                  :null => false
    t.string   "name",         :limit => 50
  end

  create_table "lookups", :force => true do |t|
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",   :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                               :default => 0
    t.string   "name",         :limit => 50
    t.string   "table_name",   :limit => 50
    t.string   "whereclause",  :limit => 250
    t.integer  "version",                     :precision => 10, :scale => 0
  end

  create_table "melting_packet_requests", :force => true do |t|
    t.integer  "company_id",                                         :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,  :default => "Y"
    t.string   "trans_flag",          :limit => 1,  :default => "A"
    t.integer  "lock_version",                      :default => 0
    t.string   "trans_bk",            :limit => 4,                   :null => false
    t.string   "trans_no",            :limit => 18,                  :null => false
    t.datetime "trans_date"
    t.string   "account_period_code", :limit => 8,                   :null => false
    t.string   "status",              :limit => 6,                   :null => false
    t.string   "customer_ref_no",     :limit => 25
    t.datetime "customer_ref_date"
    t.string   "customer_name",       :limit => 50, :default => ""
    t.string   "customer_address1",   :limit => 50, :default => ""
    t.string   "customer_address2",   :limit => 50, :default => ""
    t.string   "customer_city",       :limit => 25, :default => ""
    t.string   "customer_state",      :limit => 25, :default => ""
    t.string   "customer_zip",        :limit => 15, :default => ""
    t.string   "customer_country",    :limit => 20, :default => ""
    t.string   "customer_email_id",   :limit => 50
    t.string   "customer_phone",      :limit => 50, :default => ""
    t.string   "customer_fax",        :limit => 50, :default => ""
    t.string   "remarks"
    t.string   "packet_type",         :limit => 1,  :default => "W"
  end

  create_table "melting_retailers", :force => true do |t|
    t.integer  "company_id",                                      :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",     :limit => 1,   :default => "Y"
    t.string   "trans_flag",      :limit => 1,   :default => "A"
    t.integer  "lock_version",                   :default => 0
    t.string   "code",            :limit => 25
    t.string   "first_name",      :limit => 50
    t.string   "last_name",       :limit => 50
    t.string   "name",            :limit => 100
    t.string   "description",     :limit => 100
    t.string   "password",        :limit => 20
    t.string   "logo_file_name",  :limit => 30
    t.string   "address1",        :limit => 50,  :default => ""
    t.string   "address2",        :limit => 50,  :default => ""
    t.string   "city",            :limit => 25,  :default => ""
    t.string   "state",           :limit => 25,  :default => ""
    t.string   "zip",             :limit => 15,  :default => ""
    t.string   "country",         :limit => 20,  :default => ""
    t.string   "email_id",        :limit => 50
    t.string   "phone",           :limit => 50,  :default => ""
    t.string   "fax",             :limit => 50,  :default => ""
    t.string   "logo_file_name2", :limit => 30
  end

  create_table "melting_stage_master", :force => true do |t|
    t.integer  "company_id",                                  :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,  :default => "Y"
    t.string   "trans_flag",   :limit => 1,  :default => "A"
    t.integer  "lock_version",               :default => 0
    t.string   "stage_code",   :limit => 50
    t.string   "stage_name",   :limit => 50
    t.integer  "sequence_no"
  end

  create_table "melting_transaction_activities", :force => true do |t|
    t.integer  "company_id",                                                :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",               :limit => 1,   :default => "Y"
    t.string   "trans_flag",                :limit => 1,   :default => "A"
    t.integer  "lock_version",                             :default => 0
    t.integer  "melting_transaction_id"
    t.string   "trans_bk",                  :limit => 4,                    :null => false
    t.string   "trans_no",                  :limit => 18,                   :null => false
    t.datetime "trans_date"
    t.datetime "activity_date"
    t.string   "melting_stage_code",        :limit => 50
    t.string   "remarks",                   :limit => 100
    t.integer  "melting_packet_request_id"
  end

  create_table "melting_transaction_lines", :force => true do |t|
    t.integer  "company_id",                                                                            :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",            :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",             :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                         :default => 0
    t.integer  "melting_transaction_id",                                               :default => 0
    t.string   "description",            :limit => 100
    t.decimal  "gold_weight",                           :precision => 10, :scale => 5
    t.decimal  "gold_per",                              :precision => 5,  :scale => 2
    t.decimal  "total_value",                           :precision => 12, :scale => 2
    t.decimal  "offer_value",                           :precision => 12, :scale => 2
    t.integer  "total_pcs"
    t.string   "serial_no",              :limit => 25
  end

  create_table "melting_transactions", :force => true do |t|
    t.integer  "company_id",                                                                                 :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",                 :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",                  :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                              :default => 0
    t.string   "trans_bk",                    :limit => 4,                                                   :null => false
    t.string   "trans_no",                    :limit => 18,                                                  :null => false
    t.datetime "trans_date"
    t.string   "account_period_code",         :limit => 8,                                                   :null => false
    t.string   "status",                      :limit => 6,                                                   :null => false
    t.string   "current_melting_stage_code",  :limit => 25
    t.string   "customer_ref_no",             :limit => 25
    t.datetime "customer_ref_date"
    t.string   "retailer_ref_no",             :limit => 25
    t.datetime "retailer_ref_date"
    t.string   "receive_ship_via",            :limit => 25
    t.string   "receive_tracking_no",         :limit => 25
    t.datetime "receive_date"
    t.string   "sent_ship_via",               :limit => 25
    t.string   "sent_tracking_no",            :limit => 25
    t.datetime "ship_date"
    t.string   "customer_name",               :limit => 50,                                 :default => ""
    t.string   "customer_address1",           :limit => 50,                                 :default => ""
    t.string   "customer_address2",           :limit => 50,                                 :default => ""
    t.string   "customer_city",               :limit => 25,                                 :default => ""
    t.string   "customer_state",              :limit => 25,                                 :default => ""
    t.string   "customer_zip",                :limit => 15,                                 :default => ""
    t.string   "customer_country",            :limit => 20,                                 :default => ""
    t.string   "customer_email_id",           :limit => 50
    t.string   "customer_phone",              :limit => 50,                                 :default => ""
    t.string   "customer_fax",                :limit => 50,                                 :default => ""
    t.string   "video_file_name",             :limit => 50
    t.decimal  "offer_amt",                                  :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "check_amt",                                  :precision => 12, :scale => 2, :default => 0.0
    t.datetime "check_date"
    t.string   "check_no",                    :limit => 25
    t.decimal  "commission_amt",                             :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "commission_paid_amt",                        :precision => 12, :scale => 2, :default => 0.0
    t.datetime "commission_paid_date"
    t.decimal  "gold_rate",                                  :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "total_pcs",                                  :precision => 12, :scale => 2, :default => 0.0
    t.datetime "check_encashed_date"
    t.string   "accept_reject_flag",          :limit => 1
    t.string   "remarks",                     :limit => 100
    t.string   "salt",                        :limit => 40,                                                  :null => false
    t.string   "receivepacket",               :limit => 1,                                  :default => "N"
    t.string   "attachvideo",                 :limit => 1,                                  :default => "N"
    t.string   "updatecustomerresponse",      :limit => 1,                                  :default => "N"
    t.string   "printcheck",                  :limit => 1,                                  :default => "N"
    t.string   "updatecheckstatus",           :limit => 1,                                  :default => "N"
    t.string   "stoppayment",                 :limit => 1,                                  :default => "N"
    t.string   "returnpacket",                :limit => 1,                                  :default => "N"
    t.string   "updatecommission",            :limit => 1,                                  :default => "N"
    t.string   "retailer_store",              :limit => 50
    t.string   "customer_comments",           :limit => 500
    t.string   "metalanalysis",               :limit => 1,                                  :default => "N"
    t.string   "analysis_accept_reject_flag", :limit => 1
    t.string   "return_pkt_video_file_name",  :limit => 50
    t.datetime "gold_rate_date"
    t.string   "firstofferreminder",          :limit => 1,                                  :default => "N"
    t.string   "secondofferreminder",         :limit => 1,                                  :default => "N"
    t.string   "firstdepositreminder",        :limit => 1,                                  :default => "N"
    t.string   "seconddepositreminder",       :limit => 1,                                  :default => "N"
    t.string   "verifycheck",                 :limit => 1,                                  :default => "N"
    t.string   "barcode",                     :limit => 10
    t.string   "reject_reason_code",          :limit => 25
    t.string   "calculateoffer",              :limit => 1,                                  :default => "N"
    t.decimal  "gold10kt_weight",                            :precision => 10, :scale => 5, :default => 0.0
    t.decimal  "gold14kt_weight",                            :precision => 10, :scale => 5, :default => 0.0
    t.decimal  "gold18kt_weight",                            :precision => 10, :scale => 5, :default => 0.0
    t.decimal  "gold24kt_weight",                            :precision => 10, :scale => 5, :default => 0.0
    t.datetime "receivepacket_date"
    t.datetime "attachvideo_date"
    t.datetime "calculateoffer_date"
    t.datetime "sendoffer_date"
    t.datetime "updatecustomerresponse_date"
    t.datetime "printcheck_date"
    t.datetime "updatecheckstatus_date"
    t.datetime "stoppayment_date"
    t.datetime "returnpacket_date"
    t.datetime "updatecommission_date"
    t.datetime "retailer_store_date"
    t.datetime "customer_comments_date"
    t.datetime "metalanalysis_date"
    t.datetime "firstofferreminder_date"
    t.datetime "secondofferreminder_date"
    t.datetime "firstdepositreminder_date"
    t.datetime "seconddepositreminder_date"
    t.datetime "verifycheck_date"
    t.decimal  "total_value",                                :precision => 12, :scale => 2, :default => 0.0
    t.datetime "sendvideowithoffer_date"
    t.integer  "melting_retailer_id"
    t.decimal  "gold_weight",                                :precision => 12, :scale => 5
    t.decimal  "gold_per",                                   :precision => 6,  :scale => 2
    t.string   "sendofferwithvideo",          :limit => 1
    t.string   "open_check",                  :limit => 1
    t.string   "encashed_check",              :limit => 1
    t.datetime "commission_check_date"
    t.string   "printcommissioncheck",        :limit => 1,                                  :default => "N"
    t.datetime "printcommissioncheck_date"
    t.string   "encashcommissioncheck",       :limit => 1,                                  :default => "N"
    t.datetime "encashcommissioncheck_date"
    t.string   "encashcommissioncheck_no",    :limit => 25
    t.datetime "encash_commission_date"
    t.string   "thirdofferreminder",          :limit => 1,                                  :default => "N"
    t.datetime "thirdofferreminder_date"
    t.string   "website_user_code",           :limit => 25
    t.string   "shiplabelrequest",            :limit => 1,                                  :default => "N"
    t.datetime "shiplabelrequest_date"
    t.string   "shippacketrequest",           :limit => 1,                                  :default => "N"
    t.datetime "shippacketrequest_date"
    t.string   "label_file_name",             :limit => 100
    t.string   "shippacket_ship_via",         :limit => 25
    t.string   "shippacket_tracking_no",      :limit => 25
    t.string   "shippacketsend",              :limit => 1
    t.datetime "shippacketsend_date"
    t.string   "envelope_file_name",          :limit => 100
    t.decimal  "co_op_amt",                                  :precision => 10, :scale => 2
    t.decimal  "total_paid",                                 :precision => 10, :scale => 2
    t.integer  "melting_packet_request_id"
  end

  create_table "menus", :force => true do |t|
    t.integer  "company_id",                 :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,  :default => "Y"
    t.string   "trans_flag",   :limit => 1,  :default => "A"
    t.integer  "lock_version",               :default => 0
    t.string   "code",         :limit => 25,                  :null => false
    t.string   "menu_name",    :limit => 50
    t.integer  "moodule_id",                                  :null => false
    t.string   "menu_type",    :limit => 1,                   :null => false
    t.integer  "menu_id"
    t.integer  "document_id"
    t.integer  "sequence",                   :default => 0,   :null => false
  end

  create_table "metal_rates", :force => true do |t|
    t.integer  "company_id",                                                                   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",     :limit => 1,                                :default => "Y"
    t.string   "trans_flag",      :limit => 1,                                :default => "A"
    t.integer  "lock_version",                                                :default => 0
    t.datetime "metal_rate_date",                                                              :null => false
    t.decimal  "gold_rate",                    :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "silver_rate",                  :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "platinum_rate",                :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "palladium_rate",               :precision => 12, :scale => 2, :default => 0.0
  end

  create_table "moodules", :force => true do |t|
    t.integer  "company_id",                 :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,  :default => "Y"
    t.string   "trans_flag",   :limit => 1,  :default => "A"
    t.integer  "lock_version",               :default => 0
    t.string   "code",         :limit => 25,                  :null => false
    t.string   "moodule_name", :limit => 50
    t.integer  "sequence"
  end

  create_table "note_templates", :force => true do |t|
    t.integer  "company_id",                  :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,   :default => "Y"
    t.string   "trans_flag",   :limit => 1,   :default => "A"
    t.integer  "lock_version",                :default => 0
    t.string   "name",         :limit => 50
    t.string   "code",         :limit => 25
    t.string   "description",  :limit => 200
    t.string   "subject",      :limit => 200
  end

  create_table "notes", :force => true do |t|
    t.integer  "company_id",                  :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,   :default => "Y"
    t.string   "trans_flag",   :limit => 1,   :default => "A"
    t.integer  "lock_version",                :default => 0
    t.string   "table_name",   :limit => 30
    t.integer  "trans_id"
    t.integer  "user_id",                                      :null => false
    t.datetime "date_added"
    t.string   "subject",      :limit => 100
    t.string   "description",  :limit => 500
    t.string   "notes_type",   :limit => 1,   :default => "M"
    t.string   "email_from",   :limit => 50
    t.string   "email_to",     :limit => 500
    t.string   "email_cc",     :limit => 500
    t.string   "email_bcc",    :limit => 500
  end

  add_index "notes", ["trans_id"], :name => "notes_trans_id"

  create_table "packet_label_mappings", :force => true do |t|
    t.integer  "company_id",                                              :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,  :default => "Y"
    t.string   "trans_flag",               :limit => 1,  :default => "A"
    t.integer  "lock_version",                           :default => 0
    t.string   "generic_attribute_label",  :limit => 50
    t.string   "specific_attribute_label", :limit => 50
  end

  create_table "physical_inventories", :force => true do |t|
    t.integer  "company_id",                                         :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,  :default => "Y"
    t.string   "trans_flag",          :limit => 1,  :default => "A"
    t.integer  "lock_version",                      :default => 0
    t.string   "trans_bk",            :limit => 4,                   :null => false
    t.string   "trans_no",            :limit => 18,                  :null => false
    t.datetime "trans_date"
    t.string   "account_period_code", :limit => 8,                   :null => false
    t.string   "ext_ref_no",          :limit => 25
    t.datetime "ext_ref_date"
    t.string   "remarks"
  end

  create_table "physical_inventory_lines", :force => true do |t|
    t.integer  "company_id",                                                                             :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                          :default => 0
    t.integer  "physical_inventory_id",                                                                  :null => false
    t.string   "trans_bk",                 :limit => 4,                                                  :null => false
    t.string   "trans_no",                 :limit => 18,                                                 :null => false
    t.datetime "trans_date"
    t.string   "serial_no",                :limit => 6
    t.integer  "catalog_item_id"
    t.string   "catalog_item_code",        :limit => 25
    t.integer  "catalog_item_packet_id"
    t.string   "catalog_item_packet_code", :limit => 25
    t.string   "memo_flag",                :limit => 1
    t.decimal  "item_qty",                               :precision => 10, :scale => 2
    t.decimal  "item_price",                             :precision => 12, :scale => 2
    t.decimal  "item_amount",                            :precision => 12, :scale => 2
  end

  create_table "pos_invoice_addresses", :force => true do |t|
    t.integer  "company_id",                      :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",      :limit => 1,   :default => "Y"
    t.string   "trans_flag",       :limit => 1,   :default => "A"
    t.integer  "lock_version",                    :default => 0
    t.integer  "pos_invoice_id"
    t.string   "ship_contact1",    :limit => 50,  :default => ""
    t.string   "ship_address1",    :limit => 50,  :default => ""
    t.string   "ship_address2",    :limit => 50,  :default => ""
    t.string   "ship_phone1",      :limit => 50,  :default => ""
    t.string   "ship_fax1",        :limit => 50,  :default => ""
    t.string   "ship_city",        :limit => 25,  :default => ""
    t.string   "ship_state",       :limit => 25,  :default => ""
    t.string   "ship_zip",         :limit => 15,  :default => ""
    t.string   "ship_country",     :limit => 20,  :default => ""
    t.string   "ship_via_code",    :limit => 25,  :default => ""
    t.datetime "ship_date"
    t.string   "tracking_no",      :limit => 50
    t.string   "bill_contact1",    :limit => 50,  :default => ""
    t.string   "bill_address1",    :limit => 50,  :default => ""
    t.string   "bill_address2",    :limit => 50,  :default => ""
    t.string   "bill_phone1",      :limit => 50,  :default => ""
    t.string   "bill_fax1",        :limit => 50,  :default => ""
    t.string   "bill_city",        :limit => 25,  :default => ""
    t.string   "bill_state",       :limit => 25,  :default => ""
    t.string   "bill_zip",         :limit => 15,  :default => ""
    t.string   "bill_country",     :limit => 20,  :default => ""
    t.string   "bill_first_name",  :limit => 50
    t.string   "bill_last_name",   :limit => 50
    t.string   "ship_first_name",  :limit => 50
    t.string   "ship_last_name",   :limit => 50
    t.string   "billing_email",    :limit => 200
    t.string   "billing_cell_no",  :limit => 15
    t.string   "shipping_cell_no", :limit => 15
    t.string   "shipping_email",   :limit => 200
  end

  create_table "pos_invoice_lines", :force => true do |t|
    t.integer  "company_id",                                                             :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                  :default => "A"
    t.string   "trans_type",               :limit => 1,                                  :default => "S"
    t.integer  "lock_version",                                                           :default => 0
    t.integer  "pos_invoice_id"
    t.integer  "ref_pos_invoice_id"
    t.integer  "catalog_item_id"
    t.string   "serial_no",                :limit => 6
    t.string   "item_name",                :limit => 50
    t.string   "item_description",         :limit => 100
    t.decimal  "discount_per",                            :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "tax_per",                                 :precision => 6,  :scale => 3, :default => 0.0
    t.decimal  "item_qty",                                :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                               :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "item_price",                              :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "item_amt",                                :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                                 :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "tax_amt",                                 :precision => 12, :scale => 2, :default => 0.0
    t.datetime "trans_date"
    t.string   "trans_bk",                 :limit => 4
    t.string   "account_period_code",      :limit => 8
    t.string   "item_type",                :limit => 1
    t.integer  "catalog_item_packet_id"
    t.string   "catalog_item_code",        :limit => 25
    t.string   "trans_no",                 :limit => 18
    t.string   "catalog_item_packet_code", :limit => 25
    t.string   "customer_sku_no",          :limit => 25
    t.integer  "ref_trans_id"
    t.string   "ref_type",                 :limit => 3
    t.string   "ref_trans_no",             :limit => 18
    t.string   "ref_trans_bk",             :limit => 4
    t.string   "ref_serial_no",            :limit => 6
    t.datetime "ref_trans_date"
  end

  add_index "pos_invoice_lines", ["pos_invoice_id"], :name => "idx_pos_invoice_lines_pos_invoice_id"

  create_table "pos_invoice_payments", :force => true do |t|
    t.integer  "company_id",                                                  :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",    :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",     :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                :default => 0
    t.integer  "pos_invoice_id"
    t.string   "serial_no",      :limit => 6
    t.string   "payment_method", :limit => 50
    t.string   "reference_no",   :limit => 50
    t.decimal  "payment_amt",                  :precision => 12, :scale => 2, :default => 0.0
    t.datetime "check_date"
    t.integer  "return_amt",                   :precision => 12, :scale => 0
  end

  create_table "pos_invoices", :force => true do |t|
    t.integer  "company_id",                                                       :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                     :default => 0
    t.string   "trans_no",            :limit => 18
    t.string   "trans_bk",            :limit => 4
    t.datetime "trans_date"
    t.datetime "expiry_date"
    t.string   "account_period_code", :limit => 8
    t.string   "promo_code",          :limit => 25
    t.string   "company_store_code",  :limit => 25
    t.integer  "cashier_id"
    t.integer  "assosiate_id"
    t.integer  "customer_id"
    t.decimal  "discount_per",                      :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "tax_per",                           :precision => 6,  :scale => 3, :default => 0.0
    t.decimal  "item_amt",                          :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                      :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "tax_amt",                           :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                           :precision => 10, :scale => 2, :default => 0.0
    t.string   "term_code",           :limit => 25
    t.datetime "sales_date"
    t.string   "shipping_code",       :limit => 25
    t.datetime "due_date"
    t.datetime "ship_date"
    t.string   "trans_type",          :limit => 1
    t.decimal  "item_qty",                          :precision => 10, :scale => 2, :default => 0.0
    t.string   "ext_ref_no",          :limit => 25
    t.datetime "ext_ref_date"
    t.decimal  "other_amt",                         :precision => 12, :scale => 2, :default => 0.0
    t.string   "salesperson_code",    :limit => 25
    t.decimal  "ship_amt",                          :precision => 12, :scale => 2, :default => 0.0
    t.string   "remarks"
    t.integer  "customer_receipt_id"
  end

  create_table "pos_order_estimates", :force => true do |t|
    t.integer  "company_id",                                                                        :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                     :default => 0
    t.integer  "pos_order_id"
    t.string   "serial_no",           :limit => 6
    t.string   "item_type",           :limit => 1
    t.integer  "item_id",                                                                           :null => false
    t.string   "item_code",           :limit => 25
    t.string   "item_description"
    t.decimal  "item_cost",                         :precision => 12, :scale => 2
    t.decimal  "item_price",                        :precision => 12, :scale => 2
    t.decimal  "item_qty",                          :precision => 8,  :scale => 2
    t.decimal  "total_cost",                        :precision => 12, :scale => 2
    t.decimal  "total_amt",                         :precision => 12, :scale => 2
    t.string   "trans_bk",            :limit => 4,                                                  :null => false
    t.string   "trans_no",            :limit => 18,                                                 :null => false
    t.datetime "trans_date"
    t.string   "account_period_code", :limit => 8,                                                  :null => false
  end

  create_table "pos_order_payments", :force => true do |t|
    t.integer  "company_id",                                                                   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",    :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",     :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                :default => 0
    t.integer  "pos_order_id"
    t.string   "serial_no",      :limit => 6
    t.string   "payment_method", :limit => 50
    t.string   "reference_no",   :limit => 50
    t.decimal  "payment_amt",                  :precision => 12, :scale => 2
    t.datetime "check_date"
    t.decimal  "return_amt",                   :precision => 12, :scale => 2
  end

  create_table "pos_orders", :force => true do |t|
    t.integer  "company_id",                                                                                   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",                   :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",                    :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                                :default => 0
    t.integer  "store_id"
    t.string   "trans_bk",                      :limit => 4,                                                   :null => false
    t.string   "trans_no",                      :limit => 18,                                                  :null => false
    t.datetime "trans_date",                                                                                   :null => false
    t.string   "account_period_code",           :limit => 8,                                                   :null => false
    t.string   "trans_type",                    :limit => 1
    t.string   "ref_type",                      :limit => 1
    t.integer  "ref_trans_id"
    t.string   "ref_trans_bk",                  :limit => 4
    t.string   "ref_trans_no",                  :limit => 18
    t.datetime "ref_trans_date"
    t.integer  "customer_id"
    t.string   "bill_name",                     :limit => 50
    t.string   "bill_address1",                 :limit => 50
    t.string   "bill_address2",                 :limit => 50
    t.string   "bill_city",                     :limit => 25
    t.string   "bill_state",                    :limit => 25
    t.string   "bill_zip",                      :limit => 15
    t.string   "bill_country",                  :limit => 20
    t.string   "bill_phone",                    :limit => 50
    t.string   "bill_fax",                      :limit => 50
    t.integer  "customer_shipping_id"
    t.string   "ship_name",                     :limit => 50
    t.string   "ship_address1",                 :limit => 50
    t.string   "ship_address2",                 :limit => 50
    t.string   "ship_city",                     :limit => 25
    t.string   "ship_state",                    :limit => 25
    t.string   "ship_zip",                      :limit => 15
    t.string   "ship_country",                  :limit => 20
    t.string   "ship_phone",                    :limit => 50
    t.string   "ship_fax",                      :limit => 50
    t.string   "ext_ref_no",                    :limit => 50
    t.datetime "ext_ref_date"
    t.string   "salesperson_code",              :limit => 25
    t.integer  "cashier_id"
    t.integer  "assosiate_id"
    t.datetime "sales_date"
    t.string   "term_code",                     :limit => 25
    t.string   "shipping_code",                 :limit => 25
    t.datetime "cancel_date"
    t.datetime "due_date"
    t.datetime "ship_date"
    t.string   "tracking_no",                   :limit => 50
    t.string   "post_flag",                     :limit => 1
    t.string   "remarks"
    t.string   "customer_description"
    t.string   "internal_description"
    t.datetime "promised_date"
    t.datetime "estimated_date"
    t.decimal  "estimated_amt",                                :precision => 12, :scale => 2
    t.integer  "catalog_item_id"
    t.string   "catalog_item_code"
    t.integer  "catalog_item_packet_id"
    t.string   "catalog_item_packet_code",      :limit => 25
    t.integer  "manufacturer_vendor_id"
    t.string   "manufacturer_vendor_item_code", :limit => 25
    t.string   "metal_type",                    :limit => 25
    t.string   "metal_color",                   :limit => 25
    t.decimal  "metal_weight",                                 :precision => 12, :scale => 4
    t.integer  "stone_packet_id"
    t.integer  "stone_lot_id"
    t.string   "stone_packet_code",             :limit => 25
    t.string   "stone_lot_number",              :limit => 25
    t.string   "stone_type",                    :limit => 4
    t.string   "stone_shape",                   :limit => 18
    t.decimal  "stone_size",                                   :precision => 7,  :scale => 2
    t.string   "stone_quality",                 :limit => 18
    t.string   "stone_color",                   :limit => 18
    t.string   "stone_clarity",                 :limit => 18
    t.string   "stone_setting",                 :limit => 18
    t.decimal  "stone_weight",                                 :precision => 8,  :scale => 4
    t.integer  "stone_qty",                                    :precision => 5,  :scale => 0
    t.string   "length",                        :limit => 25
    t.string   "finish",                        :limit => 25
    t.string   "size",                          :limit => 25
    t.string   "purchased_store_code",          :limit => 25
    t.decimal  "approx_value",                                 :precision => 12, :scale => 2
    t.decimal  "approx_age",                                   :precision => 6,  :scale => 2
    t.string   "item_detail_description"
    t.decimal  "item_qty",                                     :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                                    :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "labor_total_amt",                              :precision => 12, :scale => 2
    t.decimal  "part_total_amt",                               :precision => 12, :scale => 2
    t.decimal  "item_amt",                                     :precision => 12, :scale => 2
    t.decimal  "discount_per",                                 :precision => 6,  :scale => 2
    t.decimal  "discount_amt",                                 :precision => 12, :scale => 2
    t.decimal  "tax_per",                                      :precision => 6,  :scale => 3
    t.decimal  "tax_amt",                                      :precision => 12, :scale => 2
    t.decimal  "other_amt",                                    :precision => 12, :scale => 2
    t.decimal  "ship_amt",                                     :precision => 12, :scale => 2
    t.decimal  "net_amt",                                      :precision => 12, :scale => 2
    t.decimal  "deposit_amt",                                  :precision => 12, :scale => 2
    t.decimal  "balance_amt",                                  :precision => 12, :scale => 2
    t.string   "billing_contact",               :limit => 50
    t.string   "billing_email",                 :limit => 200
    t.string   "billing_cell_no",               :limit => 15
    t.string   "shipping_cell_no",              :limit => 15
    t.string   "shipping_email",                :limit => 200
    t.string   "shipping_contact",              :limit => 50
    t.integer  "wb_trans_id"
    t.string   "wb_trans_bk",                   :limit => 4
    t.string   "wb_trans_no",                   :limit => 18
    t.datetime "wb_trans_date"
    t.string   "item_type",                     :limit => 1
    t.string   "wb_type",                       :limit => 4
    t.decimal  "item_price",                                   :precision => 10, :scale => 2, :default => 0.0
    t.string   "bill_first_name",               :limit => 50
    t.string   "bill_last_name",                :limit => 50
    t.string   "ship_first_name",               :limit => 50
    t.string   "ship_last_name",                :limit => 50
    t.integer  "customer_receipt_id"
  end

  create_table "production_requests", :force => true do |t|
    t.integer  "company_id",                                                                         :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                      :default => 0
    t.string   "trans_bk",            :limit => 4,                                                   :null => false
    t.string   "ref_trans_bk",        :limit => 4
    t.string   "po_trans_bk",         :limit => 4,                                                   :null => false
    t.string   "trans_no",            :limit => 18,                                                  :null => false
    t.string   "ref_trans_no",        :limit => 18
    t.string   "po_trans_no",         :limit => 18,                                                  :null => false
    t.string   "account_period_code", :limit => 8,                                                   :null => false
    t.datetime "trans_date",                                                                         :null => false
    t.datetime "ref_trans_date",                                                                     :null => false
    t.string   "status",              :limit => 1
    t.string   "trans_type",          :limit => 1
    t.integer  "trans_type_id"
    t.string   "po_serial_no",        :limit => 6
    t.string   "ref_serial_no",       :limit => 6
    t.integer  "company_store_id"
    t.string   "company_store_code",  :limit => 25,                                                  :null => false
    t.string   "item_type",           :limit => 1
    t.string   "ref_type",            :limit => 1
    t.integer  "catalog_item_id",                                                                    :null => false
    t.string   "catalog_item_code",   :limit => 25,                                                  :null => false
    t.string   "item_description",    :limit => 100,                                                 :null => false
    t.decimal  "discount_per",                       :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "item_qty",                           :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "ref_qty",                            :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                          :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "item_price",                         :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "item_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                       :precision => 12, :scale => 2, :default => 0.0
    t.string   "ext_ref_no",          :limit => 50
    t.datetime "ext_ref_date"
    t.integer  "po_vendor_id"
    t.datetime "ship_date"
    t.datetime "due_date"
    t.datetime "cancel_date"
  end

  create_table "purchase_credit_invoice_lines", :force => true do |t|
    t.integer  "company_id",                                                               :default => 0,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",                :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",                 :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                             :default => 0
    t.integer  "purchase_credit_invoice_id",                                                                :null => false
    t.string   "trans_bk",                   :limit => 4
    t.string   "ref_trans_bk",               :limit => 4
    t.string   "trans_no",                   :limit => 18
    t.string   "ref_trans_no",               :limit => 18
    t.datetime "trans_date"
    t.datetime "ref_trans_date"
    t.string   "account_period_code",        :limit => 8
    t.string   "serial_no",                  :limit => 6
    t.string   "ref_serial_no",              :limit => 6
    t.string   "item_type",                  :limit => 1
    t.string   "ref_type",                   :limit => 1
    t.integer  "catalog_item_id",                                                                           :null => false
    t.string   "catalog_item_code",          :limit => 25,                                                  :null => false
    t.string   "item_description",           :limit => 100,                                                 :null => false
    t.decimal  "discount_per",                              :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "item_qty",                                  :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "ref_qty",                                   :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                                 :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "item_price",                                :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "item_amt",                                  :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                                   :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                              :precision => 12, :scale => 2, :default => 0.0
    t.integer  "store_id"
    t.integer  "catalog_item_packet_id"
    t.string   "catalog_item_packet_code",   :limit => 25
    t.string   "vendor_sku_no",              :limit => 25
  end

  add_index "purchase_credit_invoice_lines", ["purchase_credit_invoice_id"], :name => "idx_purchase_credit_invoice_lines_purchase_credit_invoice_id"

  create_table "purchase_credit_invoices", :force => true do |t|
    t.integer  "company_id",                                                       :default => 0,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                     :default => 0
    t.string   "trans_bk",            :limit => 4,                                                  :null => false
    t.string   "ref_trans_bk",        :limit => 4
    t.string   "trans_no",            :limit => 18,                                                 :null => false
    t.string   "ref_trans_no",        :limit => 18
    t.datetime "trans_date",                                                                        :null => false
    t.integer  "vendor_id",                                                                         :null => false
    t.string   "account_period_code", :limit => 8,                                                  :null => false
    t.datetime "purchase_date"
    t.string   "term_code",           :limit => 25
    t.string   "shipping_code",       :limit => 25
    t.datetime "cancel_date"
    t.datetime "ship_date"
    t.datetime "ref_trans_date"
    t.string   "trans_type",          :limit => 1
    t.string   "ref_type",            :limit => 1
    t.string   "post_flag",           :limit => 1,                                 :default => "U"
    t.decimal  "item_qty",                          :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                         :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "discount_per",                      :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "tax_per",                           :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "item_amt",                          :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "tax_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                      :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.string   "remarks"
    t.string   "tracking_no",         :limit => 50
    t.string   "ship_name",           :limit => 50
    t.string   "ship_address1",       :limit => 50
    t.string   "ship_address2",       :limit => 50
    t.string   "bill_name",           :limit => 50
    t.string   "bill_address1",       :limit => 50
    t.string   "bill_address2",       :limit => 50
    t.string   "ship_city",           :limit => 25
    t.string   "ship_state",          :limit => 25
    t.string   "bill_city",           :limit => 25
    t.string   "bill_state",          :limit => 25
    t.string   "ship_zip",            :limit => 15
    t.string   "bill_zip",            :limit => 15
    t.string   "ship_country",        :limit => 20
    t.string   "bill_country",        :limit => 20
    t.string   "ship_phone",          :limit => 50
    t.string   "ship_fax",            :limit => 50
    t.string   "bill_phone",          :limit => 50
    t.string   "bill_fax",            :limit => 50
    t.datetime "due_date"
    t.string   "ext_ref_no",          :limit => 50
    t.datetime "ext_ref_date"
    t.decimal  "other_amt",                         :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "ship_amt",                          :precision => 12, :scale => 2, :default => 0.0
    t.string   "ref_no",              :limit => 18
    t.integer  "store_id"
    t.string   "purchaseperson_code", :limit => 25
  end

  add_index "purchase_credit_invoices", ["company_id", "trans_no"], :name => "purchase_credit_invoices_company_id_trans_no"

  create_table "purchase_indent_lines", :force => true do |t|
    t.integer  "company_id",                                                                         :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                      :default => 0
    t.integer  "purchase_indent_id",                                                                 :null => false
    t.string   "trans_bk",            :limit => 4
    t.string   "ref_trans_bk",        :limit => 4
    t.string   "trans_no",            :limit => 18
    t.string   "ref_trans_no",        :limit => 18
    t.datetime "trans_date"
    t.datetime "ref_trans_date"
    t.string   "account_period_code", :limit => 8
    t.string   "serial_no",           :limit => 6
    t.string   "ref_serial_no",       :limit => 6
    t.string   "item_type",           :limit => 1
    t.string   "ref_type",            :limit => 1
    t.integer  "catalog_item_id",                                                                    :null => false
    t.string   "catalog_item_code",   :limit => 25,                                                  :null => false
    t.string   "item_description",    :limit => 100,                                                 :null => false
    t.decimal  "item_qty",                           :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "ref_qty",                            :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                          :precision => 10, :scale => 2, :default => 0.0
  end

  create_table "purchase_indents", :force => true do |t|
    t.integer  "company_id",                                                                       :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                :default => "A"
    t.integer  "lock_version",                                                    :default => 0
    t.string   "trans_bk",            :limit => 4,                                                 :null => false
    t.string   "ref_trans_bk",        :limit => 4
    t.string   "trans_no",            :limit => 18,                                                :null => false
    t.string   "ref_trans_no",        :limit => 18
    t.datetime "trans_date",                                                                       :null => false
    t.string   "account_period_code", :limit => 8,                                                 :null => false
    t.datetime "indent_date"
    t.string   "term_code",           :limit => 25
    t.string   "shipping_code",       :limit => 25
    t.datetime "due_date"
    t.datetime "ship_date"
    t.datetime "ref_trans_date"
    t.string   "trans_type",          :limit => 1
    t.string   "ref_type",            :limit => 1
    t.string   "post_flag",           :limit => 1,                                :default => "U"
    t.decimal  "item_qty",                          :precision => 6, :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                         :precision => 6, :scale => 2, :default => 0.0
    t.string   "remarks"
    t.string   "tracking_no",         :limit => 50
    t.string   "ship_name",           :limit => 50
    t.string   "ship_address1",       :limit => 50
    t.string   "ship_address2",       :limit => 50
    t.string   "ship_city",           :limit => 25
    t.string   "ship_state",          :limit => 25
    t.string   "ship_zip",            :limit => 15
    t.string   "ship_country",        :limit => 20
    t.string   "ship_phone",          :limit => 50
    t.string   "ship_fax",            :limit => 50
    t.string   "ext_ref_no",          :limit => 50
    t.datetime "ext_ref_date"
    t.string   "purchaseperson_code", :limit => 25
  end

  create_table "purchase_invoice_lines", :force => true do |t|
    t.integer  "company_id",                                                             :default => 0,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                           :default => 0
    t.integer  "purchase_invoice_id",                                                                     :null => false
    t.string   "trans_bk",                 :limit => 4
    t.string   "ref_trans_bk",             :limit => 4
    t.string   "trans_no",                 :limit => 18
    t.string   "ref_trans_no",             :limit => 18
    t.datetime "trans_date"
    t.datetime "ref_trans_date"
    t.string   "account_period_code",      :limit => 8
    t.string   "serial_no",                :limit => 6
    t.string   "ref_serial_no",            :limit => 6
    t.string   "item_type",                :limit => 1,                                  :default => "I"
    t.string   "ref_type",                 :limit => 1
    t.integer  "catalog_item_id",                                                                         :null => false
    t.string   "catalog_item_code",        :limit => 25,                                                  :null => false
    t.string   "item_description",         :limit => 100,                                                 :null => false
    t.decimal  "discount_per",                            :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "item_qty",                                :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "ref_qty",                                 :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                               :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "item_price",                              :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "item_amt",                                :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                                 :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.integer  "store_id"
    t.integer  "catalog_item_packet_id"
    t.string   "catalog_item_packet_code", :limit => 25
    t.string   "vendor_sku_no",            :limit => 25
  end

  add_index "purchase_invoice_lines", ["purchase_invoice_id"], :name => "idx_purchase_invoice_lines_purchase_invoice_id"

  create_table "purchase_invoices", :force => true do |t|
    t.integer  "company_id",                                                       :default => 0,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                     :default => 0
    t.string   "trans_bk",            :limit => 4,                                                  :null => false
    t.string   "ref_trans_bk",        :limit => 4
    t.string   "trans_no",            :limit => 18,                                                 :null => false
    t.string   "ref_trans_no",        :limit => 18
    t.datetime "trans_date",                                                                        :null => false
    t.integer  "vendor_id",                                                                         :null => false
    t.string   "account_period_code", :limit => 8,                                                  :null => false
    t.datetime "purchase_date"
    t.string   "term_code",           :limit => 25
    t.string   "shipping_code",       :limit => 25
    t.datetime "cancel_date"
    t.datetime "ship_date"
    t.datetime "ref_trans_date"
    t.string   "trans_type",          :limit => 1
    t.string   "ref_type",            :limit => 1
    t.string   "post_flag",           :limit => 1,                                 :default => "U"
    t.decimal  "item_qty",                          :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                         :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "discount_per",                      :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "tax_per",                           :precision => 6,  :scale => 3, :default => 0.0
    t.decimal  "item_amt",                          :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "tax_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                      :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.string   "remarks"
    t.string   "tracking_no",         :limit => 50
    t.string   "ship_name",           :limit => 50
    t.string   "ship_address1",       :limit => 50
    t.string   "ship_address2",       :limit => 50
    t.string   "bill_name",           :limit => 50
    t.string   "bill_address1",       :limit => 50
    t.string   "bill_address2",       :limit => 50
    t.string   "ship_city",           :limit => 25
    t.string   "ship_state",          :limit => 25
    t.string   "bill_city",           :limit => 25
    t.string   "bill_state",          :limit => 25
    t.string   "ship_zip",            :limit => 15
    t.string   "bill_zip",            :limit => 15
    t.string   "ship_country",        :limit => 20
    t.string   "bill_country",        :limit => 20
    t.string   "ship_phone",          :limit => 50
    t.string   "ship_fax",            :limit => 50
    t.string   "bill_phone",          :limit => 50
    t.string   "bill_fax",            :limit => 50
    t.datetime "due_date"
    t.string   "billed_flag",         :limit => 1,                                 :default => "N"
    t.string   "ext_ref_no",          :limit => 50
    t.datetime "ext_ref_date"
    t.decimal  "other_amt",                         :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "ship_amt",                          :precision => 12, :scale => 2, :default => 0.0
    t.string   "ref_no",              :limit => 18
    t.integer  "store_id"
    t.string   "purchaseperson_code", :limit => 25
  end

  add_index "purchase_invoices", ["company_id", "trans_no"], :name => "purchase_invoices_company_id_trans_no"

  create_table "purchase_memo_lines", :force => true do |t|
    t.integer  "company_id",                                                             :default => 0,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                           :default => 0
    t.integer  "purchase_memo_id",                                                                        :null => false
    t.string   "trans_bk",                 :limit => 4
    t.string   "ref_trans_bk",             :limit => 4
    t.string   "trans_no",                 :limit => 18
    t.string   "ref_trans_no",             :limit => 18
    t.datetime "trans_date"
    t.datetime "ref_trans_date"
    t.string   "account_period_code",      :limit => 8
    t.string   "serial_no",                :limit => 6
    t.string   "ref_serial_no",            :limit => 6
    t.string   "item_type",                :limit => 1
    t.string   "ref_type",                 :limit => 1
    t.integer  "catalog_item_id",                                                                         :null => false
    t.string   "catalog_item_code",        :limit => 25,                                                  :null => false
    t.string   "item_description",         :limit => 100,                                                 :null => false
    t.decimal  "discount_per",                            :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "item_qty",                                :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "ref_qty",                                 :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                               :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "item_price",                              :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "item_amt",                                :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                                 :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.integer  "store_id"
    t.integer  "catalog_item_packet_id"
    t.string   "catalog_item_packet_code", :limit => 25
    t.string   "vendor_sku_no",            :limit => 25
  end

  add_index "purchase_memo_lines", ["purchase_memo_id"], :name => "idx_purchase_memo_lines_purchase_memo_id"

  create_table "purchase_memo_return_lines", :force => true do |t|
    t.integer  "company_id",                                                             :default => 0,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                           :default => 0
    t.integer  "purchase_memo_return_id",                                                                 :null => false
    t.string   "trans_bk",                 :limit => 4
    t.string   "ref_trans_bk",             :limit => 4
    t.string   "trans_no",                 :limit => 18
    t.string   "ref_trans_no",             :limit => 18
    t.datetime "trans_date"
    t.datetime "ref_trans_date"
    t.string   "account_period_code",      :limit => 8
    t.string   "serial_no",                :limit => 6
    t.string   "ref_serial_no",            :limit => 6
    t.string   "item_type",                :limit => 1
    t.string   "ref_type",                 :limit => 1
    t.integer  "catalog_item_id",                                                                         :null => false
    t.string   "catalog_item_code",        :limit => 25,                                                  :null => false
    t.string   "item_description",         :limit => 100,                                                 :null => false
    t.decimal  "discount_per",                            :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "item_qty",                                :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "ref_qty",                                 :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                               :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "item_price",                              :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "item_amt",                                :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                                 :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.integer  "store_id"
    t.integer  "catalog_item_packet_id"
    t.string   "catalog_item_packet_code", :limit => 25
    t.string   "vendor_sku_no",            :limit => 25
  end

  add_index "purchase_memo_return_lines", ["purchase_memo_return_id"], :name => "idx_purchase_memo_return_lines_purchase_memo_return_id"

  create_table "purchase_memo_returns", :force => true do |t|
    t.integer  "company_id",                                                       :default => 0,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                     :default => 0
    t.string   "trans_bk",            :limit => 4,                                                  :null => false
    t.string   "ref_trans_bk",        :limit => 4
    t.string   "trans_no",            :limit => 18,                                                 :null => false
    t.string   "ref_trans_no",        :limit => 18
    t.datetime "trans_date",                                                                        :null => false
    t.integer  "vendor_id",                                                                         :null => false
    t.string   "account_period_code", :limit => 8,                                                  :null => false
    t.datetime "purchase_date"
    t.string   "term_code",           :limit => 25
    t.string   "shipping_code",       :limit => 25
    t.datetime "cancel_date"
    t.datetime "ship_date"
    t.datetime "ref_trans_date"
    t.string   "trans_type",          :limit => 1
    t.string   "ref_type",            :limit => 1
    t.string   "post_flag",           :limit => 1,                                 :default => "U"
    t.decimal  "item_qty",                          :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                         :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "discount_per",                      :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "tax_per",                           :precision => 6,  :scale => 3, :default => 0.0
    t.decimal  "item_amt",                          :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "tax_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                      :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.string   "remarks"
    t.string   "tracking_no",         :limit => 50
    t.string   "ship_name",           :limit => 50
    t.string   "ship_address1",       :limit => 50
    t.string   "ship_address2",       :limit => 50
    t.string   "bill_name",           :limit => 50
    t.string   "bill_address1",       :limit => 50
    t.string   "bill_address2",       :limit => 50
    t.string   "ship_city",           :limit => 25
    t.string   "ship_state",          :limit => 25
    t.string   "bill_city",           :limit => 25
    t.string   "bill_state",          :limit => 25
    t.string   "ship_zip",            :limit => 15
    t.string   "bill_zip",            :limit => 15
    t.string   "ship_country",        :limit => 20
    t.string   "bill_country",        :limit => 20
    t.string   "ship_phone",          :limit => 50
    t.string   "ship_fax",            :limit => 50
    t.string   "bill_phone",          :limit => 50
    t.string   "bill_fax",            :limit => 50
    t.datetime "due_date"
    t.string   "ext_ref_no",          :limit => 50
    t.datetime "ext_ref_date"
    t.decimal  "other_amt",                         :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "ship_amt",                          :precision => 12, :scale => 2, :default => 0.0, :null => false
    t.string   "ref_no",              :limit => 18
    t.integer  "store_id"
    t.string   "purchaseperson_code", :limit => 25
  end

  add_index "purchase_memo_returns", ["company_id", "trans_no"], :name => "purchase_memo_returns_company_id_trans_no"

  create_table "purchase_memos", :force => true do |t|
    t.integer  "company_id",                                                       :default => 0,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                     :default => 0
    t.string   "trans_bk",            :limit => 4,                                                  :null => false
    t.string   "ref_trans_bk",        :limit => 4
    t.string   "trans_no",            :limit => 18,                                                 :null => false
    t.string   "ref_trans_no",        :limit => 18
    t.datetime "trans_date",                                                                        :null => false
    t.integer  "vendor_id",                                                                         :null => false
    t.string   "account_period_code", :limit => 8,                                                  :null => false
    t.datetime "purchase_date"
    t.string   "term_code",           :limit => 25
    t.string   "shipping_code",       :limit => 25
    t.datetime "cancel_date"
    t.datetime "ship_date"
    t.datetime "ref_trans_date"
    t.string   "trans_type",          :limit => 1
    t.string   "ref_type",            :limit => 1
    t.string   "post_flag",           :limit => 1,                                 :default => "U"
    t.decimal  "item_qty",                          :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                         :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "discount_per",                      :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "tax_per",                           :precision => 6,  :scale => 3, :default => 0.0
    t.decimal  "item_amt",                          :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "tax_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                      :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.string   "remarks"
    t.string   "tracking_no",         :limit => 50
    t.string   "ship_name",           :limit => 50
    t.string   "ship_address1",       :limit => 50
    t.string   "ship_address2",       :limit => 50
    t.string   "bill_name",           :limit => 50
    t.string   "bill_address1",       :limit => 50
    t.string   "bill_address2",       :limit => 50
    t.string   "ship_city",           :limit => 25
    t.string   "ship_state",          :limit => 25
    t.string   "bill_city",           :limit => 25
    t.string   "bill_state",          :limit => 25
    t.string   "ship_zip",            :limit => 15
    t.string   "bill_zip",            :limit => 15
    t.string   "ship_country",        :limit => 20
    t.string   "bill_country",        :limit => 20
    t.string   "ship_phone",          :limit => 50
    t.string   "ship_fax",            :limit => 50
    t.string   "bill_phone",          :limit => 50
    t.string   "bill_fax",            :limit => 50
    t.datetime "due_date"
    t.string   "ext_ref_no",          :limit => 50
    t.datetime "ext_ref_date"
    t.decimal  "other_amt",                         :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "ship_amt",                          :precision => 12, :scale => 2, :default => 0.0
    t.string   "ref_no",              :limit => 18
    t.integer  "store_id"
    t.string   "purchaseperson_code", :limit => 25
  end

  add_index "purchase_memos", ["company_id", "trans_no"], :name => "purchase_memos_company_id_trans_no"

  create_table "purchase_order_cancel_lines", :force => true do |t|
    t.integer  "company_id",                                                             :default => 0,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                           :default => 0
    t.integer  "purchase_order_cancel_id",                                                                :null => false
    t.string   "trans_bk",                 :limit => 4
    t.string   "ref_trans_bk",             :limit => 4
    t.string   "trans_no",                 :limit => 18
    t.string   "ref_trans_no",             :limit => 18
    t.datetime "trans_date"
    t.datetime "ref_trans_date"
    t.string   "account_period_code",      :limit => 8
    t.string   "serial_no",                :limit => 6
    t.string   "ref_serial_no",            :limit => 6
    t.string   "item_type",                :limit => 1
    t.string   "ref_type",                 :limit => 1
    t.integer  "catalog_item_id",                                                                         :null => false
    t.string   "catalog_item_code",        :limit => 25,                                                  :null => false
    t.string   "item_description",         :limit => 100,                                                 :null => false
    t.decimal  "discount_per",                            :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "item_qty",                                :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "ref_qty",                                 :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                               :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "item_price",                              :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "item_amt",                                :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                                 :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.integer  "store_id"
    t.integer  "catalog_item_packet_id"
    t.string   "catalog_item_packet_code", :limit => 25
    t.string   "vendor_sku_no",            :limit => 25
  end

  add_index "purchase_order_cancel_lines", ["purchase_order_cancel_id"], :name => "idx_purchase_order_cancel_lines_purchase_order_cancel_id"

  create_table "purchase_order_cancels", :force => true do |t|
    t.integer  "company_id",                                                       :default => 0,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                     :default => 0
    t.string   "trans_bk",            :limit => 4,                                                  :null => false
    t.string   "ref_trans_bk",        :limit => 4
    t.string   "trans_no",            :limit => 18,                                                 :null => false
    t.string   "ref_trans_no",        :limit => 18
    t.datetime "trans_date",                                                                        :null => false
    t.integer  "vendor_id",                                                                         :null => false
    t.string   "account_period_code", :limit => 8,                                                  :null => false
    t.datetime "purchase_date"
    t.string   "term_code",           :limit => 25
    t.string   "shipping_code",       :limit => 25
    t.datetime "cancel_date"
    t.datetime "ship_date"
    t.datetime "ref_trans_date"
    t.string   "trans_type",          :limit => 1
    t.string   "ref_type",            :limit => 1
    t.string   "post_flag",           :limit => 1,                                 :default => "U"
    t.decimal  "item_qty",                          :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                         :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "discount_per",                      :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "tax_per",                           :precision => 6,  :scale => 3, :default => 0.0
    t.decimal  "item_amt",                          :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "tax_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                      :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.string   "remarks"
    t.string   "tracking_no",         :limit => 50
    t.string   "ship_name",           :limit => 50
    t.string   "ship_address1",       :limit => 50
    t.string   "ship_address2",       :limit => 50
    t.string   "bill_name",           :limit => 50
    t.string   "bill_address1",       :limit => 50
    t.string   "bill_address2",       :limit => 50
    t.string   "ship_city",           :limit => 25
    t.string   "ship_state",          :limit => 25
    t.string   "bill_city",           :limit => 25
    t.string   "bill_state",          :limit => 25
    t.string   "ship_zip",            :limit => 15
    t.string   "bill_zip",            :limit => 15
    t.string   "ship_country",        :limit => 20
    t.string   "bill_country",        :limit => 20
    t.string   "ship_phone",          :limit => 50
    t.string   "ship_fax",            :limit => 50
    t.string   "bill_phone",          :limit => 50
    t.string   "bill_fax",            :limit => 50
    t.datetime "due_date"
    t.string   "ext_ref_no",          :limit => 50
    t.datetime "ext_ref_date"
    t.decimal  "other_amt",                         :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "ship_amt",                          :precision => 12, :scale => 2, :default => 0.0
    t.string   "ref_no",              :limit => 18
    t.integer  "store_id"
    t.string   "purchaseperson_code", :limit => 25
  end

  add_index "purchase_order_cancels", ["company_id", "trans_no"], :name => "purchase_order_cancels_company_id_trans_no"

  create_table "purchase_order_lines", :force => true do |t|
    t.integer  "company_id",                                                             :default => 0,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                           :default => 0
    t.integer  "purchase_order_id",                                                                       :null => false
    t.string   "trans_bk",                 :limit => 4
    t.string   "ref_trans_bk",             :limit => 4
    t.string   "trans_no",                 :limit => 18
    t.string   "ref_trans_no",             :limit => 18
    t.datetime "trans_date"
    t.datetime "ref_trans_date"
    t.string   "account_period_code",      :limit => 8
    t.string   "serial_no",                :limit => 6
    t.string   "ref_serial_no",            :limit => 6
    t.string   "item_type",                :limit => 1
    t.string   "ref_type",                 :limit => 1
    t.integer  "catalog_item_id",                                                                         :null => false
    t.string   "catalog_item_code",        :limit => 25,                                                  :null => false
    t.string   "item_description",         :limit => 100,                                                 :null => false
    t.decimal  "discount_per",                            :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "item_qty",                                :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "ref_qty",                                 :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                               :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "item_price",                              :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "item_amt",                                :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                                 :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.integer  "store_id"
    t.integer  "catalog_item_packet_id"
    t.string   "catalog_item_packet_code", :limit => 25
    t.string   "vendor_sku_no",            :limit => 25
  end

  add_index "purchase_order_lines", ["purchase_order_id"], :name => "idx_purchase_order_lines_purchase_order_id"

  create_table "purchase_orders", :force => true do |t|
    t.integer  "company_id",                                                       :default => 0,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                     :default => 0
    t.string   "trans_bk",            :limit => 4,                                                  :null => false
    t.string   "ref_trans_bk",        :limit => 4
    t.string   "trans_no",            :limit => 18,                                                 :null => false
    t.string   "ref_trans_no",        :limit => 18
    t.datetime "trans_date",                                                                        :null => false
    t.integer  "vendor_id",                                                                         :null => false
    t.string   "account_period_code", :limit => 8,                                                  :null => false
    t.datetime "purchase_date"
    t.string   "term_code",           :limit => 25
    t.string   "shipping_code",       :limit => 25
    t.datetime "cancel_date"
    t.datetime "ship_date"
    t.datetime "ref_trans_date"
    t.string   "trans_type",          :limit => 1
    t.string   "ref_type",            :limit => 1
    t.string   "post_flag",           :limit => 1,                                 :default => "U"
    t.decimal  "item_qty",                          :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                         :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "discount_per",                      :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "tax_per",                           :precision => 6,  :scale => 3, :default => 0.0
    t.decimal  "item_amt",                          :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "tax_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                      :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.string   "remarks"
    t.string   "tracking_no",         :limit => 50
    t.string   "ship_name",           :limit => 50
    t.string   "ship_address1",       :limit => 50
    t.string   "ship_address2",       :limit => 50
    t.string   "bill_name",           :limit => 50
    t.string   "bill_address1",       :limit => 50
    t.string   "bill_address2",       :limit => 50
    t.string   "ship_city",           :limit => 25
    t.string   "ship_state",          :limit => 25
    t.string   "bill_city",           :limit => 25
    t.string   "bill_state",          :limit => 25
    t.string   "ship_zip",            :limit => 15
    t.string   "bill_zip",            :limit => 15
    t.string   "ship_country",        :limit => 20
    t.string   "bill_country",        :limit => 20
    t.string   "ship_phone",          :limit => 50
    t.string   "ship_fax",            :limit => 50
    t.string   "bill_phone",          :limit => 50
    t.string   "bill_fax",            :limit => 50
    t.datetime "due_date"
    t.string   "ext_ref_no",          :limit => 50
    t.datetime "ext_ref_date"
    t.decimal  "other_amt",                         :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "ship_amt",                          :precision => 12, :scale => 2, :default => 0.0
    t.string   "ref_no",              :limit => 18
    t.integer  "store_id"
    t.string   "purchaseperson_code", :limit => 25
  end

  add_index "purchase_orders", ["company_id", "trans_no"], :name => "purchase_orders_company_id_trans_no"

  create_table "purchasepeople", :force => true do |t|
    t.integer  "company_id",                 :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,  :default => "Y"
    t.string   "trans_flag",   :limit => 1,  :default => "A"
    t.integer  "lock_version",               :default => 0
    t.string   "code",         :limit => 25,                  :null => false
    t.string   "name",         :limit => 50
    t.string   "address1",     :limit => 50
    t.string   "address2",     :limit => 50
    t.string   "phone1",       :limit => 50
    t.string   "fax1",         :limit => 50
    t.string   "contact1",     :limit => 50
    t.string   "city",         :limit => 25
    t.string   "state",        :limit => 25
    t.string   "zip",          :limit => 15
    t.string   "country",      :limit => 20
  end

  create_table "report_columns", :force => true do |t|
    t.integer  "company_id",                              :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,   :default => "Y"
    t.string   "trans_flag",               :limit => 1,   :default => "A"
    t.integer  "lock_version",                            :default => 0
    t.integer  "report_id",                                                :null => false
    t.string   "column_name",              :limit => 50
    t.string   "column_label",             :limit => 100
    t.string   "column_datatype",          :limit => 4
    t.string   "column_textalign",         :limit => 1,   :default => "L"
    t.integer  "column_width"
    t.string   "sortdatatype",             :limit => 4
    t.string   "isgroupable",              :limit => 1,   :default => "N"
    t.string   "isdrilldowncolumn",        :limit => 1,   :default => "N"
    t.integer  "column_precision"
    t.integer  "print_width"
    t.string   "drilldown_component_code", :limit => 100
    t.string   "isfixedurl",               :limit => 1,   :default => "N"
  end

  add_index "report_columns", ["company_id", "report_id"], :name => "report_columns_company_id_report_id"

  create_table "report_layout_columns", :force => true do |t|
    t.integer  "company_id",                    :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",      :limit => 1, :default => "Y"
    t.string   "trans_flag",       :limit => 1, :default => "A"
    t.integer  "lock_version",                  :default => 0
    t.integer  "report_layout_id",                               :null => false
    t.integer  "report_column_id",                               :null => false
    t.string   "isgroup",          :limit => 1, :default => "N"
    t.integer  "group_level"
    t.string   "istotal",          :limit => 1, :default => "N"
    t.string   "isvisible",        :limit => 1, :default => "Y"
    t.integer  "sort_sequence"
    t.integer  "column_sequence"
    t.integer  "print_width"
  end

  add_index "report_layout_columns", ["company_id", "report_layout_id"], :name => "report_layout_columns_company_id_report_layout_id"

  create_table "report_layout_users", :force => true do |t|
    t.integer  "company_id",                    :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",      :limit => 1, :default => "Y"
    t.string   "trans_flag",       :limit => 1, :default => "A"
    t.integer  "lock_version",                  :default => 0
    t.integer  "report_layout_id",                               :null => false
    t.integer  "user_id",                                        :null => false
    t.string   "default_yn",       :limit => 1, :default => "N"
  end

  create_table "report_layouts", :force => true do |t|
    t.integer  "company_id",                      :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",       :limit => 1,  :default => "Y"
    t.string   "trans_flag",        :limit => 1,  :default => "A"
    t.integer  "lock_version",                    :default => 0
    t.integer  "report_id",                                        :null => false
    t.string   "layout_type",       :limit => 1,  :default => "U"
    t.string   "name",              :limit => 50
    t.string   "print_orientation", :limit => 1,  :default => "P"
    t.integer  "lockedcolumncount",               :default => 0
  end

  add_index "report_layouts", ["company_id", "report_id"], :name => "report_layouts_company_id_report_id"

  create_table "reports", :force => true do |t|
    t.integer  "company_id",                              :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,   :default => "Y"
    t.string   "trans_flag",               :limit => 1,   :default => "A"
    t.integer  "lock_version",                            :default => 0
    t.string   "code",                     :limit => 25
    t.string   "name",                     :limit => 50
    t.string   "description",              :limit => 100
    t.integer  "document_id",                                              :null => false
    t.string   "service_url",              :limit => 500
    t.string   "drilldown_component_code", :limit => 100
    t.string   "isdrilldownrow",           :limit => 1,   :default => "N"
    t.string   "isfixedurl",               :limit => 1,   :default => "N"
  end

  create_table "role_permissions", :force => true do |t|
    t.integer  "company_id",                     :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",       :limit => 1, :default => "Y"
    t.string   "trans_flag",        :limit => 1, :default => "A"
    t.integer  "lock_version",                   :default => 0
    t.integer  "role_id",                                         :null => false
    t.integer  "document_id",                                     :null => false
    t.integer  "menu_id",                                         :null => false
    t.integer  "moodule_id",                                      :null => false
    t.string   "create_permission", :limit => 1, :default => "N", :null => false
    t.string   "modify_permission", :limit => 1, :default => "N", :null => false
    t.string   "view_permission",   :limit => 1, :default => "N", :null => false
  end

  create_table "roles", :force => true do |t|
    t.integer  "company_id",                 :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,  :default => "Y"
    t.string   "trans_flag",   :limit => 1,  :default => "A"
    t.integer  "lock_version",               :default => 0
    t.string   "code",         :limit => 25,                  :null => false
    t.string   "role_name",    :limit => 50
  end

  create_table "sales_credit_invoice_lines", :force => true do |t|
    t.integer  "company_id",                                                             :default => 0,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                           :default => 0
    t.integer  "sales_credit_invoice_id",                                                                 :null => false
    t.string   "trans_bk",                 :limit => 4
    t.string   "ref_trans_bk",             :limit => 4
    t.string   "trans_no",                 :limit => 18
    t.string   "ref_trans_no",             :limit => 18
    t.datetime "trans_date"
    t.datetime "ref_trans_date"
    t.string   "account_period_code",      :limit => 8
    t.string   "serial_no",                :limit => 6
    t.string   "ref_serial_no",            :limit => 6
    t.string   "item_type",                :limit => 1
    t.string   "ref_type",                 :limit => 1
    t.integer  "catalog_item_id",                                                                         :null => false
    t.string   "catalog_item_code",        :limit => 25,                                                  :null => false
    t.string   "item_description",         :limit => 100,                                                 :null => false
    t.decimal  "discount_per",                            :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "item_qty",                                :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "ref_qty",                                 :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                               :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "item_price",                              :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "item_amt",                                :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                                 :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.integer  "store_id"
    t.integer  "catalog_item_packet_id"
    t.string   "catalog_item_packet_code", :limit => 25
    t.string   "customer_sku_no",          :limit => 25
  end

  add_index "sales_credit_invoice_lines", ["sales_credit_invoice_id"], :name => "idx_sales_credit_invoice_lines_sales_credit_invoice_id"

  create_table "sales_credit_invoices", :force => true do |t|
    t.integer  "company_id",                                                        :default => 0,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",          :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",           :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                      :default => 0
    t.string   "trans_bk",             :limit => 4,                                                  :null => false
    t.string   "ref_trans_bk",         :limit => 4
    t.string   "trans_no",             :limit => 18,                                                 :null => false
    t.string   "ref_trans_no",         :limit => 18
    t.datetime "trans_date",                                                                         :null => false
    t.integer  "customer_id",                                                                        :null => false
    t.string   "account_period_code",  :limit => 8,                                                  :null => false
    t.datetime "sales_date"
    t.string   "term_code",            :limit => 25
    t.string   "shipping_code",        :limit => 25
    t.datetime "cancel_date"
    t.datetime "due_date"
    t.datetime "ship_date"
    t.datetime "ref_trans_date"
    t.string   "trans_type",           :limit => 1
    t.string   "ref_type",             :limit => 1
    t.string   "post_flag",            :limit => 1,                                 :default => "U"
    t.decimal  "item_qty",                           :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                          :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "discount_per",                       :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "tax_per",                            :precision => 6,  :scale => 3, :default => 0.0
    t.decimal  "item_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "tax_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                       :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.string   "remarks"
    t.string   "tracking_no",          :limit => 50
    t.string   "ship_name",            :limit => 50
    t.string   "ship_address1",        :limit => 50
    t.string   "ship_address2",        :limit => 50
    t.string   "bill_name",            :limit => 50
    t.string   "bill_address1",        :limit => 50
    t.string   "bill_address2",        :limit => 50
    t.string   "ship_city",            :limit => 25
    t.string   "ship_state",           :limit => 25
    t.string   "bill_city",            :limit => 25
    t.string   "bill_state",           :limit => 25
    t.string   "ship_zip",             :limit => 15
    t.string   "bill_zip",             :limit => 15
    t.string   "ship_country",         :limit => 20
    t.string   "bill_country",         :limit => 20
    t.string   "ship_phone",           :limit => 50
    t.string   "ship_fax",             :limit => 50
    t.string   "bill_phone",           :limit => 50
    t.string   "bill_fax",             :limit => 50
    t.string   "ext_ref_no",           :limit => 50
    t.datetime "ext_ref_date"
    t.decimal  "other_amt",                          :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "ship_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.integer  "customer_shipping_id"
    t.integer  "store_id"
    t.string   "salesperson_code",     :limit => 25
  end

  add_index "sales_credit_invoices", ["company_id", "trans_no"], :name => "sales_credit_invoices_company_id_trans_no"

  create_table "sales_invoice_lines", :force => true do |t|
    t.integer  "company_id",                                                             :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                           :default => 0
    t.integer  "sales_invoice_id",                                                                        :null => false
    t.string   "trans_bk",                 :limit => 4
    t.string   "ref_trans_bk",             :limit => 4
    t.string   "trans_no",                 :limit => 18
    t.string   "ref_trans_no",             :limit => 18
    t.datetime "trans_date"
    t.datetime "ref_trans_date"
    t.string   "account_period_code",      :limit => 8
    t.string   "serial_no",                :limit => 6
    t.string   "ref_serial_no",            :limit => 6
    t.string   "item_type",                :limit => 1
    t.string   "ref_type",                 :limit => 1
    t.integer  "catalog_item_id",                                                                         :null => false
    t.string   "catalog_item_code",        :limit => 25,                                                  :null => false
    t.string   "item_description",         :limit => 100,                                                 :null => false
    t.decimal  "discount_per",                            :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "item_qty",                                :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "ref_qty",                                 :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                               :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "item_price",                              :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "item_amt",                                :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                                 :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.integer  "store_id"
    t.integer  "catalog_item_packet_id"
    t.string   "catalog_item_packet_code", :limit => 25
    t.string   "customer_sku_no",          :limit => 25
  end

  add_index "sales_invoice_lines", ["sales_invoice_id"], :name => "idx_sales_invoice_lines_sales_invoice_id"

  create_table "sales_invoices", :force => true do |t|
    t.integer  "company_id",                                                        :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",          :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",           :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                      :default => 0
    t.string   "trans_bk",             :limit => 4,                                                  :null => false
    t.string   "ref_trans_bk",         :limit => 4
    t.string   "trans_no",             :limit => 18,                                                 :null => false
    t.string   "ref_trans_no",         :limit => 18
    t.datetime "trans_date",                                                                         :null => false
    t.integer  "customer_id",                                                                        :null => false
    t.string   "account_period_code",  :limit => 8,                                                  :null => false
    t.datetime "sales_date"
    t.string   "term_code",            :limit => 25
    t.string   "shipping_code",        :limit => 25
    t.datetime "cancel_date"
    t.datetime "due_date"
    t.datetime "ship_date"
    t.datetime "ref_trans_date"
    t.string   "trans_type",           :limit => 1
    t.string   "ref_type",             :limit => 1
    t.string   "post_flag",            :limit => 1,                                 :default => "U"
    t.decimal  "item_qty",                           :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                          :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "discount_per",                       :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "tax_per",                            :precision => 6,  :scale => 3, :default => 0.0
    t.decimal  "item_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "tax_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                       :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.string   "remarks"
    t.string   "tracking_no",          :limit => 50
    t.string   "ship_name",            :limit => 50
    t.string   "ship_address1",        :limit => 50
    t.string   "ship_address2",        :limit => 50
    t.string   "bill_name",            :limit => 50
    t.string   "bill_address1",        :limit => 50
    t.string   "bill_address2",        :limit => 50
    t.string   "ship_city",            :limit => 25
    t.string   "ship_state",           :limit => 25
    t.string   "bill_city",            :limit => 25
    t.string   "bill_state",           :limit => 25
    t.string   "ship_zip",             :limit => 15
    t.string   "bill_zip",             :limit => 15
    t.string   "ship_country",         :limit => 20
    t.string   "bill_country",         :limit => 20
    t.string   "ship_phone",           :limit => 50
    t.string   "ship_fax",             :limit => 50
    t.string   "bill_phone",           :limit => 50
    t.string   "bill_fax",             :limit => 50
    t.string   "billed_flag",          :limit => 1,                                 :default => "N"
    t.string   "ext_ref_no",           :limit => 50
    t.datetime "ext_ref_date"
    t.decimal  "other_amt",                          :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "ship_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.string   "customer_ship_code",   :limit => 25
    t.integer  "customer_shipping_id"
    t.integer  "store_id"
    t.string   "salesperson_code",     :limit => 25
  end

  add_index "sales_invoices", ["company_id", "trans_no"], :name => "sales_invoices_company_id_trans_no"

  create_table "sales_memo_lines", :force => true do |t|
    t.integer  "company_id",                                                             :default => 0,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                           :default => 0
    t.integer  "sales_memo_id",                                                                           :null => false
    t.string   "trans_bk",                 :limit => 4
    t.string   "ref_trans_bk",             :limit => 4
    t.string   "trans_no",                 :limit => 18
    t.string   "ref_trans_no",             :limit => 18
    t.datetime "trans_date"
    t.datetime "ref_trans_date"
    t.string   "account_period_code",      :limit => 8
    t.string   "serial_no",                :limit => 6
    t.string   "ref_serial_no",            :limit => 6
    t.string   "item_type",                :limit => 1
    t.string   "ref_type",                 :limit => 1
    t.integer  "catalog_item_id",                                                                         :null => false
    t.string   "catalog_item_code",        :limit => 25,                                                  :null => false
    t.string   "item_description",         :limit => 100,                                                 :null => false
    t.decimal  "discount_per",                            :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "item_qty",                                :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "ref_qty",                                 :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                               :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "item_price",                              :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "item_amt",                                :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                                 :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.integer  "store_id"
    t.integer  "catalog_item_packet_id"
    t.string   "catalog_item_packet_code", :limit => 25
    t.string   "customer_sku_no",          :limit => 25
  end

  add_index "sales_memo_lines", ["sales_memo_id"], :name => "idx_sales_memo_lines_sales_memo_id"

  create_table "sales_memo_return_lines", :force => true do |t|
    t.integer  "company_id",                                                             :default => 0,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                           :default => 0
    t.integer  "sales_memo_return_id",                                                                    :null => false
    t.string   "trans_bk",                 :limit => 4
    t.string   "ref_trans_bk",             :limit => 4
    t.string   "trans_no",                 :limit => 18
    t.string   "ref_trans_no",             :limit => 18
    t.datetime "trans_date"
    t.datetime "ref_trans_date"
    t.string   "account_period_code",      :limit => 8
    t.string   "serial_no",                :limit => 6
    t.string   "ref_serial_no",            :limit => 6
    t.string   "item_type",                :limit => 1
    t.string   "ref_type",                 :limit => 1
    t.integer  "catalog_item_id",                                                                         :null => false
    t.string   "catalog_item_code",        :limit => 25,                                                  :null => false
    t.string   "item_description",         :limit => 100,                                                 :null => false
    t.decimal  "discount_per",                            :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "item_qty",                                :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "ref_qty",                                 :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                               :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "item_price",                              :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "item_amt",                                :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                                 :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.integer  "store_id"
    t.integer  "catalog_item_packet_id"
    t.string   "catalog_item_packet_code", :limit => 25
    t.string   "customer_sku_no",          :limit => 25
  end

  add_index "sales_memo_return_lines", ["sales_memo_return_id"], :name => "idx_sales_memo_return_lines_sales_memo_return_id"

  create_table "sales_memo_returns", :force => true do |t|
    t.integer  "company_id",                                                        :default => 0,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",          :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",           :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                      :default => 0
    t.string   "trans_bk",             :limit => 4,                                                  :null => false
    t.string   "ref_trans_bk",         :limit => 4
    t.string   "trans_no",             :limit => 18,                                                 :null => false
    t.string   "ref_trans_no",         :limit => 18
    t.datetime "trans_date",                                                                         :null => false
    t.integer  "customer_id",                                                                        :null => false
    t.string   "account_period_code",  :limit => 8,                                                  :null => false
    t.datetime "sales_date"
    t.string   "term_code",            :limit => 25
    t.string   "shipping_code",        :limit => 25
    t.datetime "cancel_date"
    t.datetime "due_date"
    t.datetime "ship_date"
    t.datetime "ref_trans_date"
    t.string   "trans_type",           :limit => 1
    t.string   "ref_type",             :limit => 1
    t.string   "post_flag",            :limit => 1,                                 :default => "U"
    t.decimal  "item_qty",                           :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                          :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "discount_per",                       :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "tax_per",                            :precision => 6,  :scale => 3, :default => 0.0
    t.decimal  "item_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "tax_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                       :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.string   "remarks"
    t.string   "tracking_no",          :limit => 50
    t.string   "ship_name",            :limit => 50
    t.string   "ship_address1",        :limit => 50
    t.string   "ship_address2",        :limit => 50
    t.string   "bill_name",            :limit => 50
    t.string   "bill_address1",        :limit => 50
    t.string   "bill_address2",        :limit => 50
    t.string   "ship_city",            :limit => 25
    t.string   "ship_state",           :limit => 25
    t.string   "bill_city",            :limit => 25
    t.string   "bill_state",           :limit => 25
    t.string   "ship_zip",             :limit => 15
    t.string   "bill_zip",             :limit => 15
    t.string   "ship_country",         :limit => 20
    t.string   "bill_country",         :limit => 20
    t.string   "ship_phone",           :limit => 50
    t.string   "ship_fax",             :limit => 50
    t.string   "bill_phone",           :limit => 50
    t.string   "bill_fax",             :limit => 50
    t.string   "ext_ref_no",           :limit => 50
    t.datetime "ext_ref_date"
    t.decimal  "other_amt",                          :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "ship_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.integer  "customer_shipping_id"
    t.integer  "store_id"
    t.string   "salesperson_code",     :limit => 25
  end

  add_index "sales_memo_returns", ["company_id", "trans_no"], :name => "sales_memo_returns_company_id_trans_no"

  create_table "sales_memos", :force => true do |t|
    t.integer  "company_id",                                                        :default => 0,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",          :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",           :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                      :default => 0
    t.string   "trans_bk",             :limit => 4,                                                  :null => false
    t.string   "ref_trans_bk",         :limit => 4
    t.string   "trans_no",             :limit => 18,                                                 :null => false
    t.string   "ref_trans_no",         :limit => 18
    t.datetime "trans_date",                                                                         :null => false
    t.integer  "customer_id",                                                                        :null => false
    t.string   "account_period_code",  :limit => 8,                                                  :null => false
    t.datetime "sales_date"
    t.string   "term_code",            :limit => 25
    t.string   "shipping_code",        :limit => 25
    t.datetime "cancel_date"
    t.datetime "due_date"
    t.datetime "ship_date"
    t.datetime "ref_trans_date"
    t.string   "trans_type",           :limit => 1
    t.string   "ref_type",             :limit => 1
    t.string   "post_flag",            :limit => 1,                                 :default => "U"
    t.decimal  "item_qty",                           :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                          :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "discount_per",                       :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "tax_per",                            :precision => 6,  :scale => 3, :default => 0.0
    t.decimal  "item_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "tax_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                       :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.string   "remarks"
    t.string   "tracking_no",          :limit => 50
    t.string   "ship_name",            :limit => 50
    t.string   "ship_address1",        :limit => 50
    t.string   "ship_address2",        :limit => 50
    t.string   "bill_name",            :limit => 50
    t.string   "bill_address1",        :limit => 50
    t.string   "bill_address2",        :limit => 50
    t.string   "ship_city",            :limit => 25
    t.string   "ship_state",           :limit => 25
    t.string   "bill_city",            :limit => 25
    t.string   "bill_state",           :limit => 25
    t.string   "ship_zip",             :limit => 15
    t.string   "bill_zip",             :limit => 15
    t.string   "ship_country",         :limit => 20
    t.string   "bill_country",         :limit => 20
    t.string   "ship_phone",           :limit => 50
    t.string   "ship_fax",             :limit => 50
    t.string   "bill_phone",           :limit => 50
    t.string   "bill_fax",             :limit => 50
    t.string   "ext_ref_no",           :limit => 50
    t.datetime "ext_ref_date"
    t.decimal  "other_amt",                          :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "ship_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.integer  "customer_shipping_id"
    t.integer  "store_id"
    t.string   "salesperson_code",     :limit => 25
  end

  add_index "sales_memos", ["company_id", "trans_no"], :name => "sales_memos_company_id_trans_no"

  create_table "sales_order_cancel_lines", :force => true do |t|
    t.integer  "company_id",                                                             :default => 0,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                           :default => 0
    t.integer  "sales_order_cancel_id",                                                                   :null => false
    t.string   "trans_bk",                 :limit => 4
    t.string   "ref_trans_bk",             :limit => 4
    t.string   "trans_no",                 :limit => 18
    t.string   "ref_trans_no",             :limit => 18
    t.datetime "trans_date"
    t.datetime "ref_trans_date"
    t.string   "account_period_code",      :limit => 8
    t.string   "serial_no",                :limit => 6
    t.string   "ref_serial_no",            :limit => 6
    t.string   "item_type",                :limit => 1
    t.string   "ref_type",                 :limit => 1
    t.integer  "catalog_item_id",                                                                         :null => false
    t.string   "catalog_item_code",        :limit => 25,                                                  :null => false
    t.string   "item_description",         :limit => 100,                                                 :null => false
    t.decimal  "discount_per",                            :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "item_qty",                                :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "ref_qty",                                 :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                               :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "item_price",                              :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "item_amt",                                :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                                 :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.integer  "store_id"
    t.integer  "catalog_item_packet_id"
    t.string   "catalog_item_packet_code", :limit => 25
    t.string   "customer_sku_no",          :limit => 25
  end

  add_index "sales_order_cancel_lines", ["sales_order_cancel_id"], :name => "idx_sales_order_cancel_lines_sales_order_cancel_id"

  create_table "sales_order_cancels", :force => true do |t|
    t.integer  "company_id",                                                        :default => 0,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",          :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",           :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                      :default => 0
    t.string   "trans_bk",             :limit => 4,                                                  :null => false
    t.string   "ref_trans_bk",         :limit => 4
    t.string   "trans_no",             :limit => 18,                                                 :null => false
    t.string   "ref_trans_no",         :limit => 18
    t.datetime "trans_date",                                                                         :null => false
    t.integer  "customer_id",                                                                        :null => false
    t.string   "account_period_code",  :limit => 8,                                                  :null => false
    t.datetime "sales_date"
    t.string   "term_code",            :limit => 25
    t.string   "shipping_code",        :limit => 25
    t.datetime "cancel_date"
    t.datetime "due_date"
    t.datetime "ship_date"
    t.datetime "ref_trans_date"
    t.string   "trans_type",           :limit => 1
    t.string   "ref_type",             :limit => 1
    t.string   "post_flag",            :limit => 1,                                 :default => "U"
    t.decimal  "item_qty",                           :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                          :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "discount_per",                       :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "tax_per",                            :precision => 6,  :scale => 3, :default => 0.0
    t.decimal  "item_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "tax_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                       :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.string   "remarks"
    t.string   "tracking_no",          :limit => 50
    t.string   "ship_name",            :limit => 50
    t.string   "ship_address1",        :limit => 50
    t.string   "ship_address2",        :limit => 50
    t.string   "bill_name",            :limit => 50
    t.string   "bill_address1",        :limit => 50
    t.string   "bill_address2",        :limit => 50
    t.string   "ship_city",            :limit => 25
    t.string   "ship_state",           :limit => 25
    t.string   "bill_city",            :limit => 25
    t.string   "bill_state",           :limit => 25
    t.string   "ship_zip",             :limit => 15
    t.string   "bill_zip",             :limit => 15
    t.string   "ship_country",         :limit => 20
    t.string   "bill_country",         :limit => 20
    t.string   "ship_phone",           :limit => 50
    t.string   "ship_fax",             :limit => 50
    t.string   "bill_phone",           :limit => 50
    t.string   "bill_fax",             :limit => 50
    t.string   "ext_ref_no",           :limit => 50
    t.datetime "ext_ref_date"
    t.decimal  "other_amt",                          :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "ship_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.integer  "customer_shipping_id"
    t.integer  "store_id"
    t.string   "salesperson_code",     :limit => 25
  end

  add_index "sales_order_cancels", ["company_id", "trans_no"], :name => "sales_order_cancels_company_id_trans_no"

  create_table "sales_order_lines", :force => true do |t|
    t.integer  "company_id",                                                             :default => 0,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                           :default => 0
    t.integer  "sales_order_id",                                                                          :null => false
    t.string   "trans_bk",                 :limit => 4
    t.string   "ref_trans_bk",             :limit => 4
    t.string   "trans_no",                 :limit => 18
    t.string   "ref_trans_no",             :limit => 18
    t.datetime "trans_date"
    t.datetime "ref_trans_date"
    t.string   "account_period_code",      :limit => 8
    t.string   "serial_no",                :limit => 6
    t.string   "ref_serial_no",            :limit => 6
    t.string   "item_type",                :limit => 1
    t.string   "ref_type",                 :limit => 1
    t.integer  "catalog_item_id",                                                                         :null => false
    t.string   "catalog_item_code",        :limit => 25,                                                  :null => false
    t.string   "item_description",         :limit => 100,                                                 :null => false
    t.decimal  "discount_per",                            :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "item_qty",                                :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "ref_qty",                                 :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                               :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "item_price",                              :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "item_amt",                                :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                                 :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.integer  "store_id"
    t.integer  "catalog_item_packet_id"
    t.string   "catalog_item_packet_code", :limit => 25
    t.string   "customer_sku_no",          :limit => 25
  end

  add_index "sales_order_lines", ["sales_order_id"], :name => "idx_sales_order_lines_sales_order_id"

  create_table "sales_orders", :force => true do |t|
    t.integer  "company_id",                                                        :default => 0,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",          :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",           :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                      :default => 0
    t.string   "trans_bk",             :limit => 4,                                                  :null => false
    t.string   "ref_trans_bk",         :limit => 4
    t.string   "trans_no",             :limit => 18,                                                 :null => false
    t.string   "ref_trans_no",         :limit => 18
    t.datetime "trans_date",                                                                         :null => false
    t.integer  "customer_id",                                                                        :null => false
    t.string   "account_period_code",  :limit => 8,                                                  :null => false
    t.datetime "sales_date"
    t.string   "term_code",            :limit => 25
    t.string   "shipping_code",        :limit => 25
    t.datetime "cancel_date"
    t.datetime "due_date"
    t.datetime "ship_date"
    t.datetime "ref_trans_date"
    t.string   "trans_type",           :limit => 1
    t.string   "ref_type",             :limit => 1
    t.string   "post_flag",            :limit => 1,                                 :default => "U"
    t.decimal  "item_qty",                           :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "clear_qty",                          :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "discount_per",                       :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "tax_per",                            :precision => 6,  :scale => 3, :default => 0.0
    t.decimal  "item_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "tax_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "discount_amt",                       :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "net_amt",                            :precision => 12, :scale => 2, :default => 0.0
    t.string   "remarks"
    t.string   "tracking_no",          :limit => 50
    t.string   "ship_name",            :limit => 50
    t.string   "ship_address1",        :limit => 50
    t.string   "ship_address2",        :limit => 50
    t.string   "bill_name",            :limit => 50
    t.string   "bill_address1",        :limit => 50
    t.string   "bill_address2",        :limit => 50
    t.string   "ship_city",            :limit => 25
    t.string   "ship_state",           :limit => 25
    t.string   "bill_city",            :limit => 25
    t.string   "bill_state",           :limit => 25
    t.string   "ship_zip",             :limit => 15
    t.string   "bill_zip",             :limit => 15
    t.string   "ship_country",         :limit => 20
    t.string   "bill_country",         :limit => 20
    t.string   "ship_phone",           :limit => 50
    t.string   "ship_fax",             :limit => 50
    t.string   "bill_phone",           :limit => 50
    t.string   "bill_fax",             :limit => 50
    t.string   "ext_ref_no",           :limit => 50
    t.datetime "ext_ref_date"
    t.decimal  "other_amt",                          :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "ship_amt",                           :precision => 12, :scale => 2, :default => 0.0
    t.integer  "customer_shipping_id"
    t.integer  "store_id"
    t.string   "salesperson_code",     :limit => 25
  end

  add_index "sales_orders", ["company_id", "trans_no"], :name => "sales_orders_company_id_trans_no"

  create_table "salespeople", :force => true do |t|
    t.integer  "company_id",                                                         :default => 1,   :null => false
    t.integer  "created_by"
    t.datetime "created_at"
    t.integer  "updated_by"
    t.datetime "updated_at"
    t.string   "trans_flag",            :limit => 1,                                 :default => "A"
    t.string   "update_flag",           :limit => 1,                                 :default => "Y"
    t.integer  "lock_version",                                                       :default => 0
    t.string   "category",              :limit => 25
    t.string   "code",                  :limit => 25,                                                 :null => false
    t.string   "name",                  :limit => 50
    t.string   "address1",              :limit => 50
    t.string   "address2",              :limit => 50
    t.string   "city",                  :limit => 25
    t.string   "state",                 :limit => 25
    t.string   "zip",                   :limit => 15
    t.string   "country",               :limit => 20
    t.string   "phone1",                :limit => 50
    t.string   "fax1",                  :limit => 50
    t.string   "contact1",              :limit => 50
    t.string   "commn_type",            :limit => 4
    t.decimal  "flat_per",                             :precision => 6, :scale => 2
    t.decimal  "a_per",                                :precision => 6, :scale => 2
    t.decimal  "b_per",                                :precision => 6, :scale => 2
    t.decimal  "c_per",                                :precision => 6, :scale => 2
    t.decimal  "d_per",                                :precision => 6, :scale => 2
    t.decimal  "e_per",                                :precision => 6, :scale => 2
    t.decimal  "f_per",                                :precision => 6, :scale => 2
    t.decimal  "g_per",                                :precision => 6, :scale => 2
    t.decimal  "h_per",                                :precision => 6, :scale => 2
    t.decimal  "i_per",                                :precision => 6, :scale => 2
    t.decimal  "j_per",                                :precision => 6, :scale => 2
    t.decimal  "gross_margin_per",                     :precision => 6, :scale => 2
    t.string   "commn_payment_type",    :limit => 2,                                 :default => "A"
    t.string   "id_prefix",             :limit => 8
    t.decimal  "commission_on_receipt",                :precision => 6, :scale => 2
    t.string   "password",              :limit => 20
    t.string   "email",                 :limit => 200
  end

  create_table "salesperson_equipments", :force => true do |t|
    t.integer  "company_id",                                       :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",      :limit => 1,   :default => "Y"
    t.string   "trans_flag",       :limit => 1,   :default => "A"
    t.integer  "lock_version",                    :default => 0
    t.integer  "salesperson_id"
    t.string   "equipment_number", :limit => 100
  end

  create_table "sequences", :force => true do |t|
    t.integer  "company_id",                    :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",     :limit => 1,  :default => "Y"
    t.string   "trans_flag",      :limit => 1,  :default => "A"
    t.integer  "lock_version",                  :default => 0
    t.string   "book_cd",         :limit => 4
    t.string   "book_nm",         :limit => 30
    t.string   "book_lno",        :limit => 11
    t.string   "docu_typ",        :limit => 10
    t.string   "default_bk",      :limit => 1
    t.string   "link_bk1",        :limit => 4
    t.string   "link_bk2",        :limit => 4
    t.string   "lno_flag",        :limit => 1
    t.datetime "lno_date"
    t.string   "edit_flag",       :limit => 1
    t.string   "table_nm",        :limit => 40
    t.integer  "user_id"
    t.string   "prod_trans_type", :limit => 4
  end

  create_table "shippings", :force => true do |t|
    t.integer  "company_id",                     :default => 1,   :null => false
    t.integer  "created_by"
    t.datetime "created_at"
    t.integer  "updated_by"
    t.datetime "updated_at"
    t.string   "trans_flag",      :limit => 1,   :default => "A"
    t.string   "update_flag",     :limit => 1,   :default => "Y"
    t.integer  "lock_version",                   :default => 0
    t.string   "code",            :limit => 25,                   :null => false
    t.string   "name",            :limit => 50
    t.string   "charge_flag",     :limit => 1,   :default => "N"
    t.string   "charge_shipping", :limit => 1,   :default => "N"
    t.string   "phone",           :limit => 50
    t.string   "url",             :limit => 200
  end

  create_table "terms", :force => true do |t|
    t.string   "code",         :limit => 25,                               :default => " ", :null => false
    t.integer  "company_id",                                               :default => 1,   :null => false
    t.integer  "created_by"
    t.datetime "created_at"
    t.integer  "updated_by"
    t.datetime "updated_at"
    t.string   "trans_flag",   :limit => 1,                                :default => "A"
    t.string   "update_flag",  :limit => 1,                                :default => "Y"
    t.integer  "lock_version",                                             :default => 0
    t.string   "name",         :limit => 50
    t.decimal  "disc_per",                   :precision => 6, :scale => 2
    t.integer  "disc_days"
    t.decimal  "pay1_per",                   :precision => 6, :scale => 2
    t.integer  "pay1_days"
    t.decimal  "pay2_per",                   :precision => 6, :scale => 2
    t.integer  "pay2_days"
    t.decimal  "pay3_per",                   :precision => 6, :scale => 2
    t.integer  "pay3_days"
    t.decimal  "pay4_per",                   :precision => 6, :scale => 2
    t.integer  "pay4_days"
    t.decimal  "pay5_per",                   :precision => 6, :scale => 2
    t.integer  "pay5_days"
    t.decimal  "pay6_per",                   :precision => 6, :scale => 2
    t.integer  "pay6_days"
    t.datetime "pay1_date"
    t.datetime "pay2_date"
    t.datetime "pay3_date"
    t.datetime "pay4_date"
    t.datetime "pay5_date"
    t.datetime "pay6_date"
  end

  create_table "types", :force => true do |t|
    t.integer  "company_id",                  :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,   :default => "Y"
    t.string   "trans_flag",   :limit => 1,   :default => "A"
    t.integer  "lock_version",                :default => 0
    t.string   "type_cd",      :limit => 20,                   :null => false
    t.string   "subtype_cd",   :limit => 20,                   :null => false
    t.string   "value",        :limit => 50,                   :null => false
    t.string   "description",  :limit => 100
  end

  add_index "types", ["type_cd", "subtype_cd"], :name => "types_type_cd_subtype_cd"

  create_table "user_companies", :force => true do |t|
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1, :default => "Y"
    t.string   "trans_flag",   :limit => 1, :default => "A"
    t.integer  "lock_version",              :default => 0
    t.integer  "user_id",                                    :null => false
    t.integer  "company_id",                                 :null => false
  end

  create_table "user_permissions", :force => true do |t|
    t.integer  "company_id",                :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1, :default => "Y"
    t.string   "trans_flag",   :limit => 1, :default => "A"
    t.integer  "lock_version",              :default => 0
    t.integer  "role_id",                                    :null => false
    t.integer  "user_id",                                    :null => false
  end

  create_table "user_preferences", :force => true do |t|
    t.integer  "company_id",                                                :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",  :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",   :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                              :default => 0
    t.integer  "user_id",                                                                    :null => false
    t.integer  "document_id",                                                                :null => false
    t.string   "string1",      :limit => 50
    t.string   "string2",      :limit => 50
    t.string   "string3",      :limit => 50
    t.string   "string4",      :limit => 50
    t.string   "string5",      :limit => 50
    t.string   "string6",      :limit => 50
    t.string   "string7",      :limit => 50
    t.string   "string8",      :limit => 50
    t.string   "string9",      :limit => 50
    t.string   "string10",     :limit => 50
    t.string   "string11",     :limit => 50
    t.string   "string12",     :limit => 50
    t.string   "string13",     :limit => 50
    t.string   "string14",     :limit => 50
    t.string   "string15",     :limit => 50
    t.string   "string16",     :limit => 50
    t.string   "string17",     :limit => 50
    t.string   "string18",     :limit => 50
    t.string   "string19",     :limit => 50
    t.string   "string20",     :limit => 50
    t.datetime "date1"
    t.datetime "date2"
    t.datetime "date3"
    t.datetime "date4"
    t.datetime "date5"
    t.datetime "date6"
    t.datetime "date7"
    t.datetime "date8"
    t.datetime "date9"
    t.datetime "date10"
    t.decimal  "decimal1",                   :precision => 12, :scale => 2
    t.decimal  "decimal2",                   :precision => 12, :scale => 2
    t.decimal  "decimal3",                   :precision => 12, :scale => 2
    t.decimal  "decimal4",                   :precision => 12, :scale => 2
    t.decimal  "decimal5",                   :precision => 12, :scale => 2
    t.decimal  "decimal6",                   :precision => 12, :scale => 2
    t.decimal  "decimal7",                   :precision => 12, :scale => 2
    t.decimal  "decimal8",                   :precision => 12, :scale => 2
    t.decimal  "decimal9",                   :precision => 12, :scale => 2
    t.decimal  "decimal10",                  :precision => 12, :scale => 2
    t.string   "list1",        :limit => 50
    t.string   "list2",        :limit => 50
    t.string   "list3",        :limit => 50
    t.string   "list4",        :limit => 50
    t.string   "list5",        :limit => 50
    t.string   "list6",        :limit => 50
    t.string   "list7",        :limit => 50
    t.string   "list8",        :limit => 50
    t.string   "list9",        :limit => 50
    t.string   "list10",       :limit => 50
    t.string   "all1",         :limit => 1
    t.string   "all2",         :limit => 1
    t.string   "all3",         :limit => 1
    t.string   "all4",         :limit => 1
    t.string   "all5",         :limit => 1
    t.string   "all6",         :limit => 1
    t.string   "all7",         :limit => 1
    t.string   "all8",         :limit => 1
    t.string   "all9",         :limit => 1
    t.string   "all10",        :limit => 1
  end

  create_table "users", :force => true do |t|
    t.integer  "company_id",                              :default => 1,   :null => false
    t.integer  "created_by"
    t.datetime "created_at"
    t.integer  "updated_by"
    t.datetime "updated_at"
    t.string   "trans_flag",                :limit => 1,  :default => "A"
    t.string   "update_flag",               :limit => 1,  :default => "Y"
    t.integer  "lock_version",                            :default => 0
    t.string   "user_cd",                   :limit => 25
    t.string   "login_type",                :limit => 1,                   :null => false
    t.string   "type_id",                   :limit => 25,                  :null => false
    t.integer  "category_id"
    t.string   "login_flag",                :limit => 1,  :default => "N", :null => false
    t.datetime "password_change_date"
    t.string   "user_flag",                 :limit => 1,  :default => "A"
    t.string   "login"
    t.string   "email"
    t.string   "first_name",                :limit => 80
    t.string   "last_name",                 :limit => 80
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.integer  "last_moodule_id"
    t.string   "date_format",               :limit => 10
    t.integer  "total_logins",                            :default => 0
    t.integer  "default_company_id"
  end

  create_table "vendor_categories", :force => true do |t|
    t.integer  "company_id",                                                         :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",            :limit => 1,                                :default => "Y"
    t.string   "trans_flag",             :limit => 1,                                :default => "A"
    t.integer  "lock_version",                                                       :default => 0
    t.string   "code",                   :limit => 25,                                                :null => false
    t.string   "name",                   :limit => 50
    t.decimal  "discount_per",                         :precision => 6, :scale => 2
    t.string   "invoice_term_code",      :limit => 25
    t.string   "memo_term_code",         :limit => 25
    t.integer  "gl_account_payable_id"
    t.integer  "gl_account_expense_id"
    t.integer  "gl_discount_account_id"
  end

  create_table "vendor_invoice_lines", :force => true do |t|
    t.integer  "company_id",                                                     :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",       :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",        :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                   :default => 0
    t.string   "trans_bk",          :limit => 4
    t.string   "trans_no",          :limit => 18
    t.datetime "trans_date"
    t.string   "serial_no",         :limit => 6
    t.integer  "vendor_invoice_id"
    t.integer  "gl_account_id"
    t.decimal  "gl_amt",                          :precision => 12, :scale => 2
    t.string   "description",       :limit => 50
  end

  add_index "vendor_invoice_lines", ["vendor_invoice_id"], :name => "idx_vendor_invoice_lines_vendor_invoice_id"

  create_table "vendor_invoices", :force => true do |t|
    t.integer  "company_id",                                                       :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                     :default => 0
    t.string   "trans_bk",            :limit => 4
    t.string   "ref_trans_bk",        :limit => 4
    t.string   "trans_no",            :limit => 18
    t.string   "ref_trans_no",        :limit => 18
    t.datetime "trans_date"
    t.datetime "inv_date"
    t.datetime "due_date"
    t.datetime "discount_date"
    t.datetime "sale_date"
    t.datetime "ref_trans_date"
    t.string   "account_period_code", :limit => 25
    t.string   "post_flag",           :limit => 1
    t.string   "action_flag",         :limit => 1
    t.string   "clear_flag",          :limit => 1
    t.string   "trans_type",          :limit => 1
    t.string   "ten99_yn",            :limit => 1
    t.string   "ref_type",            :limit => 1
    t.string   "inv_type",            :limit => 4
    t.string   "inv_no",              :limit => 18
    t.integer  "vendor_id"
    t.string   "term_code",           :limit => 25
    t.string   "purchaseperson_code", :limit => 25
    t.decimal  "inv_amt",                           :precision => 12, :scale => 2
    t.decimal  "discount_amt",                      :precision => 12, :scale => 2
    t.decimal  "paid_amt",                          :precision => 12, :scale => 2
    t.decimal  "disctaken_amt",                     :precision => 12, :scale => 2
    t.decimal  "balance_amt",                       :precision => 12, :scale => 2
    t.decimal  "clear_amt",                         :precision => 12, :scale => 2
    t.decimal  "item_qty",                          :precision => 12, :scale => 2
    t.decimal  "ten99_amt",                         :precision => 12, :scale => 2
    t.decimal  "discount_per",                      :precision => 6,  :scale => 2
    t.string   "description",         :limit => 50
  end

  add_index "vendor_invoices", ["company_id", "trans_bk", "trans_no"], :name => "vendor_invoices_company_id_trans_bk_trans_no"

  create_table "vendor_payment_lines", :force => true do |t|
    t.integer  "company_id",                                                     :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",       :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",        :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                   :default => 0
    t.string   "trans_bk",          :limit => 4
    t.string   "trans_no",          :limit => 18
    t.string   "voucher_no",        :limit => 18
    t.datetime "trans_date"
    t.datetime "voucher_date"
    t.datetime "due_date"
    t.string   "serial_no",         :limit => 6
    t.string   "voucher_flag",      :limit => 1
    t.string   "apply_flag",        :limit => 1
    t.integer  "vendor_payment_id"
    t.integer  "gl_account_id"
    t.decimal  "original_amt",                    :precision => 12, :scale => 2
    t.decimal  "apply_amt",                       :precision => 12, :scale => 2
    t.decimal  "balance_amt",                     :precision => 12, :scale => 2
    t.decimal  "disctaken_amt",                   :precision => 12, :scale => 2
    t.string   "apply_to",          :limit => 10
    t.string   "ref_no",            :limit => 20
  end

  add_index "vendor_payment_lines", ["vendor_payment_id"], :name => "idx_vendor_payment_lines_vendor_payment_id"

  create_table "vendor_payments", :force => true do |t|
    t.integer  "company_id",                                                       :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                     :default => 0
    t.string   "trans_bk",            :limit => 4
    t.string   "trans_no",            :limit => 18
    t.datetime "trans_date"
    t.datetime "check_date"
    t.datetime "due_date"
    t.string   "account_period_code", :limit => 8
    t.string   "post_flag",           :limit => 1
    t.string   "action_flag",         :limit => 1
    t.string   "trans_type",          :limit => 1
    t.string   "payment_type",        :limit => 4
    t.integer  "vendor_id"
    t.integer  "soldto_id"
    t.integer  "bank_id"
    t.string   "term_code",           :limit => 25
    t.string   "purchaseperson_code", :limit => 25
    t.decimal  "paid_amt",                          :precision => 12, :scale => 2
    t.decimal  "applied_amt",                       :precision => 12, :scale => 2
    t.decimal  "balance_amt",                       :precision => 12, :scale => 2
    t.decimal  "item_qty",                          :precision => 12, :scale => 2
    t.string   "check_no",            :limit => 15
    t.string   "description",         :limit => 50
    t.string   "deposit_no",          :limit => 15
  end

  add_index "vendor_payments", ["company_id", "trans_bk", "trans_no"], :name => "vendor_payments_company_id_trans_bk_trans_no"

  create_table "vendors", :force => true do |t|
    t.integer  "company_id",                                                        :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                      :default => 0
    t.string   "code",                :limit => 25,                                                  :null => false
    t.string   "first_name",          :limit => 50,                                 :default => ""
    t.string   "last_name",           :limit => 50,                                 :default => ""
    t.string   "name",                :limit => 100,                                :default => ""
    t.integer  "vendor_category_id",                                                                 :null => false
    t.string   "invoice_term_code",   :limit => 25
    t.string   "memo_term_code",      :limit => 25
    t.decimal  "credit_limit",                       :precision => 12, :scale => 2
    t.string   "price_level",         :limit => 1,                                  :default => "A"
    t.string   "address1",            :limit => 50,                                 :default => ""
    t.string   "address2",            :limit => 50,                                 :default => ""
    t.string   "city",                :limit => 25,                                 :default => ""
    t.string   "state",               :limit => 25,                                 :default => ""
    t.string   "zip",                 :limit => 15,                                 :default => ""
    t.string   "country",             :limit => 20,                                 :default => ""
    t.string   "phone",               :limit => 50,                                 :default => ""
    t.string   "fax",                 :limit => 50,                                 :default => ""
    t.string   "cell_no",             :limit => 15,                                 :default => ""
    t.string   "email_to",            :limit => 200,                                :default => ""
    t.string   "email_cc",            :limit => 200,                                :default => ""
    t.decimal  "discount_per",                       :precision => 5,  :scale => 2, :default => 0.0
    t.integer  "gl_account_id"
    t.string   "purchaseperson_code", :limit => 25
    t.string   "shipping_code",       :limit => 25
    t.string   "lab_yn",              :limit => 1,                                  :default => "N"
    t.string   "logo_file_name",      :limit => 50
  end

  create_table "website_users", :force => true do |t|
    t.integer  "company_id",                               :default => 1,   :null => false
    t.integer  "created_by"
    t.datetime "created_at"
    t.integer  "updated_by"
    t.datetime "updated_at"
    t.string   "trans_flag",                :limit => 1,   :default => "A"
    t.string   "update_flag",               :limit => 1,   :default => "Y"
    t.integer  "lock_version",                             :default => 0
    t.string   "code",                      :limit => 25
    t.string   "email",                     :limit => 50
    t.string   "first_name",                :limit => 100
    t.string   "last_name",                 :limit => 100
    t.string   "address1",                  :limit => 50
    t.string   "address2",                  :limit => 50
    t.string   "business_phone",            :limit => 50
    t.string   "home_phone",                :limit => 50
    t.string   "cell_phone",                :limit => 50
    t.string   "fax",                       :limit => 50
    t.string   "city",                      :limit => 25,  :default => ""
    t.string   "state",                     :limit => 25,  :default => ""
    t.string   "zip",                       :limit => 15,  :default => ""
    t.string   "country",                   :limit => 20,  :default => ""
    t.string   "crypted_password",          :limit => 50
    t.string   "salt",                      :limit => 50
    t.datetime "password_change_date"
    t.string   "remember_token",            :limit => 1
    t.datetime "remember_token_expires_at"
    t.string   "date_format",               :limit => 10
    t.integer  "total_logins",                             :default => 0
  end

  create_table "wishlists", :force => true do |t|
    t.integer  "company_id",                      :default => 1,   :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",      :limit => 1,   :default => "Y"
    t.string   "trans_flag",       :limit => 1,   :default => "A"
    t.integer  "lock_version",                    :default => 0
    t.integer  "user_id",                         :default => 0
    t.string   "comments",         :limit => 200
    t.datetime "wish_date"
    t.integer  "catalog_item_id",                                  :null => false
    t.integer  "customer_id",                                      :null => false
    t.string   "spo_flag",         :limit => 1,   :default => "N"
    t.string   "spo_size",         :limit => 25
    t.string   "spo_head_size",    :limit => 25
    t.string   "spo_metal_type",   :limit => 25
    t.string   "spo_diamond_qlty", :limit => 25
    t.string   "spo_metal_color",  :limit => 25
  end

  create_table "workbag_item_issues", :force => true do |t|
    t.integer  "company_id",                                                                             :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                          :default => 0
    t.integer  "workbag_id"
    t.string   "trans_bk",                 :limit => 4,                                                  :null => false
    t.string   "trans_no",                 :limit => 18,                                                 :null => false
    t.datetime "trans_date"
    t.string   "account_period_code",      :limit => 8,                                                  :null => false
    t.string   "serial_no",                :limit => 6
    t.string   "item_type",                :limit => 1
    t.integer  "catalog_item_id",                                                                        :null => false
    t.string   "catalog_item_code",        :limit => 25
    t.integer  "catalog_item_packet_id"
    t.string   "catalog_item_packet_code", :limit => 25
    t.string   "item_description"
    t.string   "metal_type",               :limit => 25
    t.string   "metal_color",              :limit => 25
    t.string   "size",                     :limit => 25
    t.string   "unit",                     :limit => 4
    t.decimal  "wt",                                     :precision => 12, :scale => 4
    t.decimal  "cost",                                   :precision => 12, :scale => 2
    t.decimal  "price",                                  :precision => 12, :scale => 2
    t.decimal  "qty",                                    :precision => 6,  :scale => 2
    t.decimal  "total_wt",                               :precision => 12, :scale => 4
    t.decimal  "total_cost",                             :precision => 12, :scale => 2
    t.decimal  "total_amt",                              :precision => 12, :scale => 2
  end

  create_table "workbag_labor_issues", :force => true do |t|
    t.integer  "company_id",                                                                         :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                  :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                  :default => "A"
    t.integer  "lock_version",                                                      :default => 0
    t.integer  "workbag_id"
    t.string   "trans_bk",            :limit => 4,                                                   :null => false
    t.string   "trans_no",            :limit => 18,                                                  :null => false
    t.datetime "trans_date"
    t.string   "account_period_code", :limit => 8,                                                   :null => false
    t.string   "serial_no",           :limit => 6
    t.string   "labor_type",          :limit => 25
    t.integer  "labor_id"
    t.string   "labor_code",          :limit => 25
    t.string   "labor_description",   :limit => 25
    t.decimal  "cost",                               :precision => 12, :scale => 2
    t.decimal  "price",                              :precision => 12, :scale => 2
    t.decimal  "qty",                                :precision => 6,  :scale => 2
    t.decimal  "total_cost",                         :precision => 12, :scale => 2
    t.decimal  "total_amt",                          :precision => 12, :scale => 2
    t.string   "remarks",             :limit => 100
  end

  create_table "workbag_stage_transfer_lines", :force => true do |t|
    t.integer  "company_id",                                                                             :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",               :limit => 1,                                :default => "Y"
    t.string   "trans_flag",                :limit => 1,                                :default => "A"
    t.integer  "lock_version",                                                          :default => 0
    t.integer  "workbag_stage_transfer_id",                                                              :null => false
    t.string   "trans_bk",                  :limit => 4,                                                 :null => false
    t.string   "trans_no",                  :limit => 18,                                                :null => false
    t.datetime "trans_date"
    t.string   "trans_type",                :limit => 1
    t.string   "account_period_code",       :limit => 8,                                                 :null => false
    t.string   "serial_no",                 :limit => 6
    t.integer  "ref_trans_id"
    t.string   "ref_trans_bk",              :limit => 4
    t.string   "ref_trans_no",              :limit => 18
    t.datetime "ref_trans_date"
    t.string   "ref_type",                  :limit => 1
    t.decimal  "ref_qty",                                 :precision => 6, :scale => 2
    t.string   "item_type",                 :limit => 1
    t.integer  "catalog_item_id"
    t.string   "catalog_item_code"
    t.string   "catalog_item_description",  :limit => 50
    t.integer  "catalog_item_packet_id"
    t.string   "catalog_item_packet_code",  :limit => 25
    t.string   "from_stage",                :limit => 25
    t.string   "to_stage",                  :limit => 25
    t.decimal  "trans_qty",                               :precision => 6, :scale => 2
  end

  create_table "workbag_stage_transfers", :force => true do |t|
    t.integer  "company_id",                                         :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,  :default => "Y"
    t.string   "trans_flag",          :limit => 1,  :default => "A"
    t.integer  "lock_version",                      :default => 0
    t.string   "trans_bk",            :limit => 4,                   :null => false
    t.string   "trans_no",            :limit => 18,                  :null => false
    t.datetime "trans_date"
    t.string   "trans_type",          :limit => 1
    t.string   "account_period_code", :limit => 8,                   :null => false
    t.string   "ext_ref_no",          :limit => 50
    t.datetime "ext_ref_date"
    t.string   "workbag_flag",        :limit => 1
    t.string   "remarks"
    t.string   "stage_to",            :limit => 25
  end

  create_table "workbag_stages", :force => true do |t|
    t.integer  "company_id",                                    :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",    :limit => 1,  :default => "Y"
    t.string   "trans_flag",     :limit => 1,  :default => "A"
    t.integer  "lock_version",                 :default => 0
    t.string   "code",           :limit => 25
    t.string   "name",           :limit => 50
    t.string   "onhand_stage",   :limit => 1
    t.string   "receive_stage",  :limit => 1
    t.string   "close_stage",    :limit => 1
    t.integer  "sequence_no"
    t.string   "allow_transfer", :limit => 1
    t.string   "finish_flag",    :limit => 1
  end

  create_table "workbag_stone_issues", :force => true do |t|
    t.integer  "company_id",                                                                        :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",         :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",          :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                     :default => 0
    t.integer  "workbag_id"
    t.string   "trans_bk",            :limit => 4,                                                  :null => false
    t.string   "trans_no",            :limit => 18,                                                 :null => false
    t.datetime "trans_date"
    t.string   "account_period_code", :limit => 8,                                                  :null => false
    t.string   "serial_no",           :limit => 6
    t.string   "item_type",           :limit => 1
    t.integer  "stone_lot_id"
    t.string   "stone_lot_number",    :limit => 25
    t.integer  "stone_packet_id"
    t.string   "stone_packet_code",   :limit => 25
    t.string   "stone_type",          :limit => 18
    t.string   "stone_shape",         :limit => 18
    t.decimal  "stone_size",                        :precision => 7,  :scale => 2
    t.string   "stone_quality",       :limit => 18
    t.string   "stone_color",         :limit => 18
    t.string   "stone_clarity",       :limit => 18
    t.string   "stone_setting",       :limit => 18
    t.decimal  "wt",                                :precision => 12, :scale => 3
    t.decimal  "cost",                              :precision => 12, :scale => 2
    t.decimal  "price",                             :precision => 12, :scale => 2
    t.decimal  "qty",                               :precision => 6,  :scale => 2
    t.decimal  "total_wt",                          :precision => 12, :scale => 3
    t.decimal  "total_cost",                        :precision => 12, :scale => 2
    t.decimal  "total_amt",                         :precision => 12, :scale => 2
  end

  create_table "workbags", :force => true do |t|
    t.integer  "company_id",                                                                             :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_flag",              :limit => 1,                                 :default => "Y"
    t.string   "trans_flag",               :limit => 1,                                 :default => "A"
    t.integer  "lock_version",                                                          :default => 0
    t.string   "trans_bk",                 :limit => 4,                                                  :null => false
    t.string   "trans_no",                 :limit => 18,                                                 :null => false
    t.datetime "trans_date"
    t.string   "trans_type",               :limit => 1
    t.string   "account_period_code",      :limit => 8,                                                  :null => false
    t.integer  "ref_trans_id"
    t.string   "ref_trans_bk",             :limit => 4
    t.string   "ref_trans_no",             :limit => 18
    t.datetime "ref_trans_date"
    t.string   "ref_type",                 :limit => 1
    t.decimal  "ref_qty",                                :precision => 6,  :scale => 2
    t.integer  "customer_id"
    t.string   "customer_name",            :limit => 50
    t.string   "ext_ref_no",               :limit => 50
    t.datetime "ext_ref_date"
    t.string   "post_flag",                :limit => 1
    t.integer  "store_id"
    t.decimal  "wb_qty",                                 :precision => 12, :scale => 2
    t.string   "open_flag",                :limit => 1
    t.string   "internal_description"
    t.string   "remarks"
    t.integer  "catalog_item_id"
    t.string   "catalog_item_code",        :limit => 25
    t.string   "catalog_item_description", :limit => 50
    t.integer  "catalog_item_packet_id"
    t.string   "catalog_item_packet_code", :limit => 25
    t.integer  "po_vendor_id"
    t.integer  "vendor_po_id"
    t.string   "vendor_po_no",             :limit => 25
    t.datetime "vendor_po_date"
    t.decimal  "vendor_po_qty",                          :precision => 6,  :scale => 2
    t.string   "current_stage",            :limit => 25
    t.string   "current_status",           :limit => 25
    t.datetime "estimated_date"
    t.string   "vendor_instruction"
    t.string   "metal_type",               :limit => 25
    t.string   "metal_color",              :limit => 25
    t.decimal  "metal_weight",                           :precision => 12, :scale => 4
    t.integer  "stone_lot_id"
    t.string   "stone_lot_number",         :limit => 25
    t.integer  "stone_packet_id"
    t.string   "stone_packet_code",        :limit => 25
    t.string   "stone_type",               :limit => 4
    t.string   "stone_shape",              :limit => 18
    t.decimal  "stone_size",                             :precision => 7,  :scale => 2
    t.string   "stone_quality",            :limit => 18
    t.string   "stone_color",              :limit => 18
    t.string   "stone_clarity",            :limit => 18
    t.string   "stone_setting",            :limit => 18
    t.decimal  "stone_weight",                           :precision => 8,  :scale => 4
    t.integer  "stone_qty",                              :precision => 5,  :scale => 0
    t.string   "size",                     :limit => 25
    t.string   "length",                   :limit => 25
    t.string   "finish",                   :limit => 25
    t.integer  "memo_vendor_id"
    t.integer  "vendor_memo_id"
    t.string   "item_type",                :limit => 1
    t.string   "vendor_memo_no",           :limit => 25
    t.string   "vendor_po_bk",             :limit => 4
    t.string   "vendor_memo_bk",           :limit => 4
    t.string   "wb_type",                  :limit => 4
    t.datetime "vendor_memo_date"
    t.decimal  "vendor_memo_qty",                        :precision => 12, :scale => 2
    t.decimal  "item_price",                             :precision => 10, :scale => 2, :default => 0.0
  end

end
