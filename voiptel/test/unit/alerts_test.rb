require 'test_helper'

class AlertsTest < ActionMailer::TestCase
  test "cid_problem" do
    @expected.subject = 'Alerts#cid_problem'
    @expected.body    = read_fixture('cid_problem')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Alerts.create_cid_problem(@expected.date).encoded
  end

end
