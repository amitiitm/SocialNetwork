require File.dirname(__FILE__) + '/../spec_helper'

describe RatePlan do
  it "should be valid" do
    RatePlan.new.should be_valid
  end
end
