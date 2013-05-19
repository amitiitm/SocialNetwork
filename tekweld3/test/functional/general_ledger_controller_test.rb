require File.dirname(__FILE__) + '/../test_helper'

class GeneralLedgerControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  include TestMethods
  fixtures :gl_accounts, :banks, :gl_categories
   
  def setup
    @controller = GeneralLedgerController.new  
    @request    = ActionController::TestRequest.new  
    @response   = ActionController::TestRespons e.new
  end
  
  def test_show_gl_category
    xml = '<params>         
              <id>1</id>     
          </params>' 
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :show_gl_category,{}, {:schema => "#{test_schema}"} 
    assert_template 'generic_view/list_master'
    assert_response :success
#    assert_equal [], assigns(:gl_categories)[0].errors.full_messages   
    assert_not_nil(assigns(:gl_categories)[0],'record not found') 
  end
  
   def test_list_gl_categories
    xml = '<criteria>         
              <str1>stationary</str1>     
              <str2>stationary</str2> 
              <str3>stationary</str3>     
              <str4>stationary</str4>  
              <str5>A</str5> 
              <str6>A</str6> 
          </criteria>' 
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :list_gl_category,{}, {:schema => "#{test_schema}"} 
    assert_template 'generic_view/list_master'
    assert_response :success
#    assert_equal [], assigns(:gl_categories)[0].errors.full_messages   
    assert_not_nil(assigns(:gl_categories)[0],'record not found') 
  end
  
   def test_create_gl_categories
    xml = '<gl_categories>   
                  <gl_category>     
                        <id></id>     
                        <code>stationary</code>     
                        <name>stationary</name> 
                        <account_type>DB</account_type> 
                        <tb_seq_no>4</tb_seq_no>  
                  </gl_category> 
            </gl_categories>' 
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :create_gl_category,{}, {:schema => "#{test_schema}"} 
    assert_template 'generic_view/create_master'
    assert_response :success
    assert_equal [], assigns(:gl_categories)[0].errors.full_messages   
    assert_valid assigns(:gl_categories)[0]
  end
  
  def test_create_gl_accounts
    xml = '<gl_accounts>   
                  <gl_account>     
                        <id></id>     
                        <code>bank</code>     
                        <name>Bank</name> 
                        <trans_flag>A</trans_flag>     
                        <company_id>1</company_id>     
                        <created_by>45</created_by>     
                        <updated_by>45</updated_by>     
                        <lock_version>0</lock_version>   
                        <group1>grp1</group1>  
                        <group2>grp2</group2>  
                        <group3>grp3</group3>  
                        <group4>grp4</group4>  
                        <acct_flag>A</acct_flag> 
                        <tb_seq_no>4</tb_seq_no>  
                  </gl_account> 
            </gl_accounts>' 
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :create_gl_accounts,{}, {:schema => "#{test_schema}"} 
    assert_template 'generic_view/create_master'
    assert_response :success
    assert_equal [], assigns(:gl_accounts)[0].errors.full_messages   
    assert_valid assigns(:gl_accounts)[0]
  end
  
  def test_create_banks
    xml = '<banks>   
                  <bank>     
                        <id>100</id>     
                        <code>HSBC</code>     
                        <name>HSBCupd</name> 
                        <trans_flag>A</trans_flag>     
                        <company_id>1</company_id>     
                        <created_by>45</created_by>     
                        <updated_by>45</updated_by>     
                        <lock_version>0</lock_version>   
                        <balance>12</balance> 
                        <gl_category_id>1</gl_category_id> 
                        <credit_limit>378.46</credit_limit> 
                        <bank_acct_no>123456</bank_acct_no> 
                        <account_type>V</account_type>  
                  </bank> 
            </banks>' 
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :create_banks,{}, {:schema => "#{test_schema}"} 
    assert_template 'generic_view/create_master'
    assert_response :success
    assert_equal [], assigns(:banks)[0].errors.full_messages   
    assert_valid assigns(:banks)[0]
  end
  
end


