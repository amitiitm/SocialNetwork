module CdrsHelper
  def cdr_phone_type(phone)
    return "N/A" unless phone
    (phone.phone_type == 2)? "MOB" : "FIX"
  end
end
