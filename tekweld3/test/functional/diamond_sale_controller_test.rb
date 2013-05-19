require File.dirname(__FILE__) + '/../test_helper'

class DiamondSaleControllerTest < ActionController::TestCase
  include TestMethods  

  fixtures :customers
  fixtures :sequences
  fixtures :customer_invoices
  fixtures :customer_receipts
  fixtures :gl_transactions
  fixtures :gl_transaction_lines  

  directory = File.join(File.dirname(__FILE__),"../fixtures/diamond_sale")
  Fixtures.create_fixtures(directory, "diamond_sales")
  Fixtures.create_fixtures(directory, "diamond_sale_lines")
  Fixtures.create_fixtures(directory, "diamond_inventory_details")
  Fixtures.create_fixtures(directory, "diamond_inventory_summaries")
  directory = File.join(File.dirname(__FILE__),"../fixtures/diamond")
  Fixtures.create_fixtures(directory, "diamond_lots")

  def setup
    @controller = DiamondSaleController.new  
    @request    = ActionController::TestRequest.new  
    @response   = ActionController::TestRespons e.new
  end
  
  def test_truth
    assert true
  end

  def test_list_memos
    xml = '<criteria>   
                        <str1></str1>     
                        <str2>zzzz</str2> 
                        <str3></str3>     
                        <str4>zzzz</str4>     
                        <dt1>1950-01-01 00:00:00</dt1>     
                        <dt2>2999-12-31 00:00:00</dt2>     
            </criteria>' 
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :list_memos,{}, {:schema => "#{test_schema}"} 
    assert_template 'diamond_sale/list_memos'
    #assert_equal [], assigns(:memos)[0].errors.full_messages
  end
  
  def test_show_memo
    xml = '<params>
              <id>100</id>
          </params>'  
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :show_memo,{}, {:schema => "#{test_schema}"} 
    assert_template 'diamond_sale/show_memo'
    assert_equal [], assigns(:memo).errors.full_messages   
  end

  def test_list_invoices
    xml = '<criteria>   
                        <str1></str1>     
                        <str2>zzzz</str2> 
                        <str3></str3>     
                        <str4>zzzz</str4>     
                        <dt1>1950-01-01 00:00:00</dt1>     
                        <dt2>2999-12-31 00:00:00</dt2>     
            </criteria>' 
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :list_invoices,{}, {:schema => "#{test_schema}"} 
    assert_template 'diamond_sale/list_invoices'
    #assert_equal [], assigns(:invoices)[0].errors.full_messages
  end
  
  def test_list_credits
    xml = '<criteria>   
                        <str1></str1>     
                        <str2>zzzz</str2> 
                        <str3></str3>     
                        <str4>zzzz</str4>     
                        <dt1>1950-01-01 00:00:00</dt1>     
                        <dt2>2999-12-31 00:00:00</dt2>     
            </criteria>' 
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :list_credits,{}, {:schema => "#{test_schema}"}
    assert_template 'diamond_sale/list_credits'
    #assert_equal [], assigns(:credits)[0].errors.full_messages
  end

  def test_list_memoreturns
    xml = '<criteria>   
                        <str1></str1>     
                        <str2>zzzz</str2> 
                        <str3></str3>     
                        <str4>zzzz</str4>     
                        <dt1>1950-01-01 00:00:00</dt1>     
                        <dt2>2999-12-31 00:00:00</dt2>     
            </criteria>' 
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :list_memoreturns,{}, {:schema => "#{test_schema}"} 
    assert_template 'diamond_sale/list_memoreturns'
    #assert_equal [], assigns(:memoreturns)[0].errors.full_messages
  end

  def test_show_invoice
    xml = '<params>
              <id>101</id>
          </params>'  
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :show_invoice,{}, {:schema => "#{test_schema}"} 
    assert_template 'diamond_sale/show_invoice'
    assert_equal [], assigns(:invoice).errors.full_messages   
  end

  def test_show_memoreturn
    xml = '<params>
              <id>102</id>
          </params>'  
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :show_memoreturn,{}, {:schema => "#{test_schema}"} 
    assert_template 'diamond_sale/show_memoreturn'
    assert_equal [], assigns(:memoreturn).errors.full_messages   
  end
  
  def test_show_credit
    xml = '<params>
              <id>103</id>
          </params>'  
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :show_credit,{}, {:schema => "#{test_schema}"} 
    assert_template 'diamond_sale/show_credit'
    assert_equal [], assigns(:credit).errors.full_messages   
  end

  def test_create_memos
    xml = '<diamond_sales> 
            <diamond_sale> 
                        <id></id>     
                        <trans_bk></trans_bk>
                        <trans_no></trans_no>
                        <trans_date>2009-10-12 00:00:00</trans_date>
                        <customer_id>100</customer_id>
                        <trans_flag>A</trans_flag>
                        <account_period_code>200910</account_period_code>
                        <diamond_sale_lines>
                          <diamond_sale_line>
                            <id></id>     
                            <trans_bk></trans_bk>
                            <trans_no></trans_no>
                            <trans_date>2009-10-12 00:00:00</trans_date>
                            <serial_no>101</serial_no>
                            <diamond_lot_id>100</diamond_lot_id>
                            <diamond_sale_id></diamond_sale_id>
                            <pcs>5</pcs>
                            <clear_pcs>0</clear_pcs>
                            <wt>5</wt>
                            <clear_wt>0</clear_wt>
                          </diamond_sale_line>
                        </diamond_sale_lines>
            </diamond_sale>
          </diamond_sales>' 
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :create_memos,{}, {:schema => "#{test_schema}"}
    assert_template 'diamond_sale/create_memos'
    assert_equal [], assigns(:memos)[0].errors.full_messages   
  end
 
  def test_create_invoices
    xml = '<diamond_sales> 
            <diamond_sale> 
                        <id></id>     
                        <trans_bk></trans_bk>
                        <trans_no></trans_no>
                        <trans_date>2009-10-12 00:00:00</trans_date>
                        <customer_id>100</customer_id>
                        <trans_flag>A</trans_flag>
                        <account_period_code>200910</account_period_code>
                        <lines_amt>11007.60</lines_amt>
                        <ship_amt>20.00</ship_amt>
                        <insurance_amt>30.00</insurance_amt>
                        <tax_amt>0.00</tax_amt>
                        <discount_amt>10.00</discount_amt>
                        <other_amt>50.00</other_amt>
                        <net_amt>11097.60</net_amt>
                        <diamond_sale_lines>
                          <diamond_sale_line>
                            <id></id>     
                            <trans_bk></trans_bk>
                            <trans_no></trans_no>
                            <trans_date>2009-10-12 00:00:00</trans_date>
                            <trans_flag>A</trans_flag>
                            <diamond_lot_id>100</diamond_lot_id>
                            <serial_no>100</serial_no>
                            <price>11007.60</price>
                            <line_amt>11007.60</line_amt>
                            <discount_amt>0.00</discount_amt>
                            <net_amt>11007.60</net_amt>
                            <pcs>1</pcs>
                            <clear_pcs>0</clear_pcs>
                            <wt>1</wt>
                            <clear_wt>0</clear_wt>
                            <ref_trans_bk>SM01</ref_trans_bk>
                            <ref_trans_no>10001</ref_trans_no>
                            <ref_trans_date>2009-10-07 00:00:00</ref_trans_date>
                            <ref_serial_no>100</ref_serial_no>
                          </diamond_sale_line>
                        </diamond_sale_lines>
            </diamond_sale>
          </diamond_sales>' 
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :create_invoices,{}, {:schema => "#{test_schema}"} 
    assert_template 'diamond_sale/create_invoices'
    assert_equal [], assigns(:invoices)[0].errors.full_messages   
  end

  def test_create_credits
    xml = '<diamond_sales> 
            <diamond_sale> 
                        <id></id>     
                        <trans_bk></trans_bk>
                        <trans_no></trans_no>
                        <trans_date>2009-10-12 00:00:00</trans_date>
                        <customer_id>100</customer_id>
                        <trans_flag>A</trans_flag>
                        <account_period_code>200910</account_period_code>
                        <lines_amt>200</lines_amt>
                        <net_amt>200</net_amt>
                        <diamond_sale_lines>
                          <diamond_sale_line>
                            <id></id>     
                            <trans_bk></trans_bk>
                            <trans_no></trans_no>
                            <trans_date>2009-10-12 00:00:00</trans_date>
                            <diamond_lot_id>100</diamond_lot_id>
                            <pcs>1</pcs>
                            <clear_pcs>0</clear_pcs>
                            <wt>1</wt>
                            <clear_wt>0</clear_wt>
                            <line_amt>200.00</line_amt>
                            <discount_amt>0.00</discount_amt>
                            <net_amt>200.00</net_amt>
                            <ref_trans_bk>SI01</ref_trans_bk>
                            <ref_trans_no>10002</ref_trans_no>
                            <ref_trans_date>2009-10-12 00:00:00</ref_trans_date>
                            <ref_serial_no>100</ref_serial_no>
                          </diamond_sale_line>
                        </diamond_sale_lines>
            </diamond_sale>
          </diamond_sales>' 
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :create_credits,{}, {:schema => "#{test_schema}"} 
    assert_template 'diamond_sale/create_credits'
    assert_equal [], assigns(:credits)[0].errors.full_messages   
  end

  def test_create_memoreturns
    xml = '<diamond_sales> 
            <diamond_sale> 
                        <id></id>     
                        <trans_bk></trans_bk>
                        <trans_no></trans_no>
                        <trans_date>2009-10-12 00:00:00</trans_date>
                        <customer_id>100</customer_id>
                        <diamond_sale_lines>
                          <diamond_sale_line>
                            <id></id>     
                            <trans_bk></trans_bk>
                            <trans_no></trans_no>
                            <trans_date>2009-10-12 00:00:00</trans_date>
                            <diamond_lot_id>100</diamond_lot_id>
                            <pcs>2</pcs>
                            <clear_pcs>0</clear_pcs>
                            <wt>2</wt>
                            <clear_wt>0</clear_wt>
                            <ref_trans_bk>SM01</ref_trans_bk>
                            <ref_trans_no>10001</ref_trans_no>
                            <ref_trans_date>2009-10-07 00:00:00</ref_trans_date>
                            <ref_serial_no>100</ref_serial_no>
                          </diamond_sale_line>
                        </diamond_sale_lines>
            </diamond_sale>
          </diamond_sales>' 
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :create_memoreturns,{}, {:schema => "#{test_schema}"} 
    assert_template 'diamond_sale/create_memoreturns'
    assert_equal [], assigns(:memoreturns)[0].errors.full_messages   
  end

  def test_fetch_open_memos
    xml = '<criteria>   
                        <int1>0</int1>     
                        <int2>9999</int2> 
                        <str1></str1>     
                        <str2>zzzz</str2> 
                        <dt1>1950-01-01 00:00:00</dt1>     
                        <dt2>2999-12-31 00:00:00</dt2>     
            </criteria>' 
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :fetch_open_memos,{}, {:schema => "#{test_schema}"} 
    assert_template 'diamond_sale/fetch_open_memos'
   # assert_equal [], assigns(:memos)[0].errors.full_messages
  end

  def test_fetch_open_invoices
    xml = '<criteria>   
                        <int1>0</int1>     
                        <int2>9999</int2> 
                        <str1></str1>     
                        <str2>zzzz</str2> 
                        <dt1>1950-01-01 00:00:00</dt1>     
                        <dt2>2999-12-31 00:00:00</dt2>     
            </criteria>' 
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :fetch_open_invoices,{}, {:schema => "#{test_schema}"} 
    assert_template 'diamond_sale/fetch_open_invoices'
   # assert_equal [], assigns(:memos)[0].errors.full_messages
  end

  def test_fetch_customer_details
    xml = '<params>   
               <id>100</id>         
           </params>' 
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :fetch_customer_details,{}, {:schema => "#{test_schema}"} 
    assert_template 'diamond_sale/fetch_customer_details'
   # assert_equal [], assigns(:memos)[0].errors.full_messages
  end
  
end
