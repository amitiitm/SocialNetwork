require File.dirname(__FILE__) + '/../test_helper'
require 'note_controller'

class NoteControllerTest < ActionController::TestCase

  def setup
    @controller = NoteController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_list_notes
    @request.env['RAW_POST_DATA'] = %{
        <criteria>   
                <str1>po</str1>   
                <str2>100</str2>   
                <str3></str3>   
                <str4>ZZZZ</str4>   
                <str5></str5>   
                <str6>ZZZZ</str6> 
        </criteria> }
    
    get :list_notes
    assert_response :success
    assert_equal 'application/xml', @response.content_type
  end  
end
