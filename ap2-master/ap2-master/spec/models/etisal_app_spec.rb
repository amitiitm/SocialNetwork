require File.dirname(__FILE__) + '/../spec_helper'

describe EtisalApp do
  it "should be valid" do
    EtisalApp.new.should be_valid
  end
end
