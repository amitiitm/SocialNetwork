module Accounts::AccountPromotionsHelper
  def account_account_promotions_path(*args)
    account_promotions_path(args)
  end
  
  def account_account_promotion_path(*args)
    "/accounts/#{args[0].id}/promotions/#{args[1].id}"
  end
  
  def expiration(p)
    exp = (p.created_at + p.days.days)
    if exp < Time.now
      "<span class='red'>Expirated on #{user_date(exp)}</span>"
    else
      "In " + distance_of_time_in_words(Time.now, exp)
    end
  end
end
