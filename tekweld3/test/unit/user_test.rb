require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  

  def test_should_create_user
    assert_difference 'Admin::User.count' do
      user = create_user
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_login
    assert_no_difference 'Admin::User.count' do
      u = create_user(:login => nil)
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference 'Admin::User.count' do
      u = create_user(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference 'Admin::User.count' do
      u = create_user(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference 'Admin::User.count' do
      u = create_user(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_reset_password
    u = Admin::User.find_by_user_cd('martin')
    #users(:martin).update_attributes(:password => 'jewel', :password_confirmation => 'jewel')
    u.update_attributes(:password => 'jewel', :password_confirmation => 'new jewel')
    #assert_equal users(:martin), Admin::User.authenticate('martin', 'jewel')
    assert_equal u, Admin::User.authenticate('martin', 'jewel')
  end
=begin
  def test_should_not_rehash_password
    u = Admin::User.find_by_user_cd('martin')
    u.update_attributes(:login => 'john')
    #users(:martin).update_attributes(:login => 'john')
    #assert_equal users(:martin), Admin::User.authenticate('john', 'jewel')
    assert_equal u, Admin::User.authenticate('john', 'jewel')
  end
=end
  def test_should_authenticate_user
    u = Admin::User.find_by_user_cd('martin')
    #assert_equal users(:martin), Admin::User.authenticate('martin', 'jewel')
    assert_equal u, Admin::User.authenticate('martin', 'jewel')
  end

  def test_should_set_remember_token
    u = Admin::User.find_by_user_cd('martin')
    #users(:martin).remember_me
    #assert_not_nil users(:martin).remember_token
    #assert_not_nil users(:martin).remember_token_expires_at
    u.remember_me
    assert_not_nil u.remember_token
    assert_not_nil u.remember_token_expires_at
  end

  def test_should_unset_remember_token
    u = Admin::User.find_by_user_cd('martin')
    u.remember_me
    assert_not_nil u.remember_token
    u.forget_me
    assert_nil u.remember_token
    #users(:martin).remember_me
    #assert_not_nil users(:martin).remember_token
    #users(:martin).forget_me
    #assert_nil users(:martin).remember_token
  end

  def test_should_remember_me_for_one_week
    u = Admin::User.find_by_user_cd('martin')
    before = 1.week.from_now.utc
    u.remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil u.remember_token
    assert_not_nil u.remember_token_expires_at
    assert u.remember_token_expires_at.between?(before, after)
  end

  def test_should_remember_me_until_one_week
    u = Admin::User.find_by_user_cd('martin')
    time = 1.week.from_now.utc
    u.remember_me_until time
    assert_not_nil u.remember_token
    assert_not_nil u.remember_token_expires_at
    assert_equal u.remember_token_expires_at, time
  end

  def test_should_remember_me_default_two_weeks
    u = Admin::User.find_by_user_cd('martin')
    before = 2.weeks.from_now.utc
    u.remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil u.remember_token
    assert_not_nil u.remember_token_expires_at
    assert u.remember_token_expires_at.between?(before, after)
  end

protected
  def create_user(options = {})
    Admin::User.create({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
  end

end


