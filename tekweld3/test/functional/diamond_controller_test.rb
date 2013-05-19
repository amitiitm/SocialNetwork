require File.dirname(__FILE__) + '/../test_helper'

class DiamondControllerTest < ActionController::TestCase
  include TestMethods  
  
  directory = File.join(File.dirname(__FILE__),"../fixtures/diamond")
  Fixtures.create_fixtures(directory, "diamond_categories")
  Fixtures.create_fixtures(directory, "diamond_lots")
  Fixtures.create_fixtures(directory, "diamond_packets")

  def setup
    @controller = DiamondController.new  
    @request    = ActionController::TestRequest.new  
    @response   = ActionController::TestRespons e.new
  end
  
  def test_truth
    assert true
  end
  
  def test_list_categories
    xml = '<criteria>   
                        <str1></str1>     
                        <str2>zzzz</str2> 
                        <str3></str3>     
                        <str4>zzzz</str4>     
                        <str5></str5>     
                        <str6>zzzz</str6>     
                        
            </criteria>' 
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :list_categories,{}, {:schema => "#{test_schema}"} 
    assert_template 'generic_view/list_master'
  end

  def test_list_lots
    xml = '<criteria>   
                        <str1></str1>     
                        <str2>zzzz</str2> 
                        <str3></str3>     
                        <str4>zzzz</str4>     
                        <str5></str5>     
                        <str6>zzzz</str6>     
                        
            </criteria>' 
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :list_lots,{}, {:schema => "#{test_schema}"} 
    assert_template 'generic_view/list_master'
  end

  def test_list_packets
    xml = '<criteria>   
                        <str1></str1>     
                        <str2>zzzz</str2> 
                        <str3></str3>     
                        <str4>zzzz</str4>     
                        <str5></str5>     
                        <str6>zzzz</str6>     
                        
            </criteria>' 
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :list_packets,{}, {:schema => "#{test_schema}"} 
    assert_template 'generic_view/list_master'
  end

  def test_show_category
    xml = '<params>
              <id>100</id>
          </params>'  
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :show_category,{}, {:schema => "#{test_schema}"} 
    assert_template 'generic_view/list_master'
    assert_not_nil(assigns(:category)[0],'record not found') 
  end

  def test_show_lot
    xml = '<params>
              <id>100</id>
          </params>'  
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :show_lot,{}, {:schema => "#{test_schema}"} 
    assert_template 'generic_view/list_master'
    assert_not_nil(assigns(:lot)[0],'record not found') 
  end
  
  def test_show_packet
    xml = '<params>
              <id>100</id>
          </params>'  
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :show_packet,{}, {:schema => "#{test_schema}"} 
    assert_template 'generic_view/list_master'
    assert_not_nil(assigns(:packet)[0],'record not found') 
  end

  def test_create_categories
    xml = '<diamond_categories> 
            <diamond_category> 
                        <id></id>     
                        <code>ED</code>     
                        <name>Emerald Diamond</name> 
            </diamond_category>
            </diamond_categories>' 
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :create_categories,{}, {:schema => "#{test_schema}"} 
    assert_template 'generic_view/create_master'
   assert_equal [], assigns(:categories)[0].errors.full_messages   
  end
  
  def test_create_lots
    xml = '<diamond_lots> 
            <diamond_lot> 
                        <id></id>     
                        <lot_number>ED001</lot_number>     
                        <description>Emerald Diamond</description> 
                        <diamond_category_id>100</diamond_category_id>
            </diamond_lot>
            </diamond_lots>' 
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :create_lots,{}, {:schema => "#{test_schema}"} 
    assert_template 'generic_view/create_master'
    assert_equal [], assigns(:lots)[0].errors.full_messages   
  end

  def test_create_packets
    xml = '<diamond_packets> 
            <diamond_packet> 
                        <id></id>     
                        <packet_no>ED001</packet_no>     
                        <diamond_lot_id>100</diamond_lot_id> 
            </diamond_packet>
            </diamond_packets>' 
    @request.env['RAW_POST_DATA'] = xml
    @request.env['HTTP_CONTENT_TYPE'] = 'application/xml'  
    @request.env['CONTENT_TYPE'] = 'application/xml'  
    post :create_packets,{}, {:schema => "#{test_schema}"} 
    assert_template 'generic_view/create_master'
    assert_equal [], assigns(:packets)[0].errors.full_messages   
  end

end
