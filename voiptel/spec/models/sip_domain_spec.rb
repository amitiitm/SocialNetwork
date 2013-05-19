require File.dirname(__FILE__) + '/../spec_helper'

describe SipDomain do
  it "should be valid" do
    SipDomain.new.should be_valid
  end
end
