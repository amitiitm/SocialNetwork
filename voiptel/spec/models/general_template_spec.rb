require File.dirname(__FILE__) + '/../spec_helper'

describe GeneralTemplate do
  it "should be valid" do
    GeneralTemplate.new.should be_valid
  end
end
