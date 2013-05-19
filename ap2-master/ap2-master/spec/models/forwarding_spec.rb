require File.dirname(__FILE__) + '/../spec_helper'

describe Forwarding do
  it "should be valid" do
    Forwarding.new.should be_valid
  end
end
