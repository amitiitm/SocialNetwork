require File.dirname(__FILE__) + '/../spec_helper'

describe VoiceTestimonial do
  it "should be valid" do
    VoiceTestimonial.new.should be_valid
  end
end
