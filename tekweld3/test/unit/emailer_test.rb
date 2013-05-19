require File.dirname(__FILE__) + '/../test_helper'

class OrderMailerTest < ActionMailer::TestCase
=begin
  tests OrderMailer
  def test_sent_order
    @expected.subject = 'OrderMailer#sentorder'
    @expected.body    = read_fixture('sent_order')
    @expected.date    = Time.now

    assert_equal @expected.encoded, OrderMailer.create_sent_order(@expected.date).encoded
  end
=end
end
