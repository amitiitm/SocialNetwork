require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  tests Notifier
  def test_tehran_promo_update
    @expected.subject = 'Notifier#tehran_promo_update'
    @expected.body    = read_fixture('tehran_promo_update')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifier.create_tehran_promo_update(@expected.date).encoded
  end

end
