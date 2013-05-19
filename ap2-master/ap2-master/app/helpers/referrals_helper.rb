module ReferralsHelper
  def referral_status(r)
    if r.mapped
      "Matched"
    else
      link_to("Click to Match", edit_referral_path(r), :class => "ajax", :update => "container")
    end
  end
end
