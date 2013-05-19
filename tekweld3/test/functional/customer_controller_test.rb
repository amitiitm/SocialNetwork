require File.dirname(__FILE__) + '/../test_helper'
class CustomerControllerTest < ActionController::TestCase
  include TestMethods
  fixtures :customers, :customer_invoices, :customer_invoice_lines, :customer_receipts, :customer_receipt_lines
#   Replace this with your real tests.
#  def test_truth
#    assert true
#  end
  
  def setup
#    Connection.establish_connection_schema('railstest')
    @controller = CustomerController.new  
    @request    = ActionController::TestRequest.new  
    @response   = ActionController::TestRespons e.new
  end
  
#  def test_createcustomer
#    xml = '<customers>   
#                  <customer>     
#                        <id></id>     
#                        <code>bindu</code>     
#                        <name>Bindu</name> 
#                        <trans_flag>A</trans_flag>     
#                        <company_id>1</company_id>     
#                        <created_by>45</created_by>     
#                        <updated_by>45</updated_by>     
#                        <lock_version>0</lock_version>   
#                        <jbtrankings>
#                           <jbtranking>
#                               <id></id>
#                               <jbt_ranking>JBT1</jbt_ranking>
#                               <serial_no>1</serial_no>
#                              <company_id>1</company_id>     
#                               <lock_version>0</lock_version>   
#                           </jbtranking>
#                           <jbtranking>
#                               <id></id>
#                               <jbt_ranking>JBT2</jbt_ranking>
#                               <serial_no>2</serial_no>
#                              <company_id>1</company_id>     
#                               <lock_version>0</lock_version>   
#                           </jbtranking>
#                        </jbtrankings>
#                        <shippings>
#                           <shipping>
#                               <id></id>
#                               <code>S1</code>
#                               <name>S1 Name</name>
#                               <company_id>1</company_id>     
#                               <lock_version>0</lock_version>   
#                           </shipping>
#                        </shippings>
#                        <notes>
#                           <note>
#                               <id></id>
#                               <serial_no>1</serial_no>
#                               <daily_notes>First Note</daily_notes>
#                               <company_id>1</company_id>     
#                               <lock_version>0</lock_version>   
#                           </note>
#                        </notes>
#                  </customer> 
#            </customers>' 
#    @request.env['RAW_POST_DATA'] = xml
#    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
#    @request.env['CONTENT_TYPE'] = 'application/xml'  
#   post :create_customers,{}, {:schema => "#{test_schema}"} 
#    assert_template 'customer/create_customers'
#    assert_response :success
#    assert_equal [], assigns(:customers)[0].errors.full_messages   
#    assert_valid assigns(:customers)[0]
#  end
#  
#  def test_createinvoice
#    xml = '<customer_invoices>   
#                  <customer_invoice>     
#                        <id></id>     
#                        <customer_id>100</customer_id>  
#                        <trans_bk>IN01</trans_bk>     
#                        <trans_date>2009-09-30 15:04:18.0</trans_date> 
#                        <account_period_code>200910</account_period_code> 
#                        <inv_type>I</inv_type>  
#                        <trans_flag>A</trans_flag>     
#                        <company_id>1</company_id>     
#                        <created_by>45</created_by>     
#                        <updated_by>45</updated_by>     
#                        <lock_version>0</lock_version>     
#                    <customer_invoice_lines> 
#                      <customer_invoice_line> 
#                        <id></id>     
#                        <serial_no>100</serial_no>   
#                        <gl_account_id>100</gl_account_id>   
#                        <company_id>1</company_id>     
#                        <created_by>45</created_by>     
#                        <updated_by>45</updated_by> 
#                        <gl_amt>100</gl_amt> 
#                       </customer_invoice_line> 
#                    </customer_invoice_lines> 
#                  </customer_invoice> 
#              </customer_invoices>' 
#    
#    @request.env['RAW_POST_DATA'] = xml
#    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
#    @request.env['CONTENT_TYPE'] = 'application/xml'  
#    post :create_invoices,{}, {:schema => "#{test_schema}"} 
#    assert_template 'customer/create_invoices'
#    assert_response :success
#    assert_equal [], assigns(:customer_invoices)[0].errors.full_messages   
#    assert_valid assigns(:customer_invoices)[0]
#  end
#  
#  def test_updateinvoice
#    xml = '<customer_invoices>   
#                  <customer_invoice>     
#                        <id>100</id>     
#                        <customer_id>200</customer_id>  
#                        <trans_bk>IN01</trans_bk>     
#                        <trans_date>2009-09-30 15:04:18.0</trans_date> 
#                        <account_period_code>200909</account_period_code> 
#                        <inv_type>I</inv_type>  
#                        <trans_flag>A</trans_flag>     
#                        <company_id>1</company_id>     
#                        <created_by>45</created_by>     
#                        <updated_by>45</updated_by>     
#                        <lock_version>0</lock_version>     
#                    <customer_invoice_lines> 
#                      <customer_invoice_line> 
#                        <id></id>     
#                        <serial_no>100</serial_no>   
#                        <gl_account_id>100</gl_account_id>   
#                        <company_id>1</company_id>     
#                        <created_by>45</created_by>     
#                        <updated_by>45</updated_by> 
#                        <gl_amt>100</gl_amt> 
#                       </customer_invoice_line> 
#                    </customer_invoice_lines> 
#                  </customer_invoice> 
#              </customer_invoices>' 
#    
#    @request.env['RAW_POST_DATA'] = xml
#    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
#    @request.env['CONTENT_TYPE'] = 'application/xml'  
#   post :create_invoices,{}, {:schema => "#{test_schema}"} 
#    assert_template 'customer/create_invoices'
#    assert_response :success
#    assert_equal [], assigns(:customer_invoices)[0].errors.full_messages   
#    assert_valid assigns(:customer_invoices)[0]
#  end
#  
# def test_fetch_invoice
#    xml = '<params>   
#               <customer_id>100</customer_id>         
#            </params>' 
#    @request.env['RAW_POST_DATA'] = xml
#    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
#    @request.env['CONTENT_TYPE'] = 'application/xml'  
#    post :fetch_invoices_for_receipts,{}, {:schema => "#{test_schema}"} 
#    assert_template 'customer/fetch_invoices_for_receipts'
#    assert_response :success
#    assert_valid assigns(:customer_invoices)[0]
# end
 
  def test_createreceipt
    xml = '<customer_receipts>   
                  <customer_receipt>     
                        <id>102</id> 
                        <trans_no>1003</trans_no> 
                        <customer_id>100</customer_id>  
                        <trans_bk>RE01</trans_bk>     
                        <trans_date>2009-09-30 15:04:18.0</trans_date> 
                        <account_period_code>200910</account_period_code> 
                        <receipt_type>C</receipt_type>  
                        <applied_amt>5800</applied_amt>  
                        <trans_flag>A</trans_flag>     
                        <company_id>1</company_id>     
                        <created_by>45</created_by>     
                        <updated_by>45</updated_by>     
                        <lock_version>0</lock_version>     
                    <customer_receipt_lines> 
                      <customer_receipt_line> 
                        <id>100</id>  
                         <trans_no>1003</trans_no> 
                         <voucher_no>IN011001</voucher_no> 
                         <trans_flag>D</trans_flag> 
                       </customer_receipt_line> 
                    </customer_receipt_lines> 
                  </customer_receipt> 
              </customer_receipts>' 
    
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :create_receipts,{}, {:schema => "#{test_schema}"} 
    assert_template 'customer/create_receipts'
    assert_response :success
    assert_equal [], assigns(:customer_receipts)[0].errors.full_messages   
    assert_valid assigns(:customer_receipts)[0]
  end

  def test_show_customer_shippings
    xml = '<params>
              <id>100</id>
          </params>'  
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :show_customer_shippings,{}, {:schema => "#{test_schema}"} 
    assert_template 'generic_view/list_master'
    assert_not_nil(assigns(:shippings)[0],'record not found') 
  end
  
end
