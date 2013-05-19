require File.dirname(__FILE__) + '/../test_helper'

class CatalogControllerTest < ActionController::TestCase
  fixtures :catalog_groups
  # Replace this with your real tests.
  def setup
    Connectionschema.establish_connection_schema('railstest')
    @controller = CustomerController.new  
    @request    = ActionController::TestRequest.new  
    @response   = ActionController::TestRespons e.new
  end
  
  def test_creategroup
    xml = '<groups>   
                  <group>     
                        <id></id>     
                        <code>bangle</code>     
                        <name>Bangle round</name> 
                        <trans_flag>A</trans_flag>        
                        <lock_version>0</lock_version>   
                  </group> 
            </groups>' 
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :create_groups,{}, {:schema => 'railstest'}
    assert_template 'customer/create_groups'
    assert_response :success
    assert_nil assigns(:groups)[0].errors
    assert_valid assigns(:groups)[0]
  end
  
  def test_updategroup
    xml = '<groups>   
                  <group>     
                        <id>100</id>     
                        <code>Ring</code>     
                        <name>Wedding Band</name> 
                        <trans_flag>A</trans_flag>        
                        <lock_version>0</lock_version>   
                  </group> 
            </groups>' 
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :create_groups,{}, {:schema => 'railstest'} 
    assert_template 'customer/create_groups'
    assert_response :success
    assert_nil assigns(:groups)[0].errors
    assert_valid assigns(:groups)[0]
  end
end
