require File.dirname(__FILE__) + '/../spec_helper'

describe ProductTax do
  it "should be valid" do
    ProductTax.new.should be_valid
  end
end
