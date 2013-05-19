require File.dirname(__FILE__) + '/../spec_helper'

describe Notifications do
  it "should be valid" do
    Notifications.new.should be_valid
  end
end
