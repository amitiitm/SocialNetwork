require File.dirname(__FILE__) + '/../spec_helper'

describe Ivr do
  it "should be valid" do
    Ivr.new.should be_valid
  end
end
