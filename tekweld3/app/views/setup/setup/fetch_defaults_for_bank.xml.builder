xml.instruct! :xml, :version=>"1.0" 
xml.banks{
  xml.bank do
    xml.check_no(@check_no)
    xml.deposit_slip_no(@deposit_slip_no)
    xml.payment_type(@payment_type)
    xml.check_no_flag(@check_no_flag)
    xml.bank_id(@bank_id)
    xml.bank_code(@bank_code)
    xml.bank_name(@bank_name)
    xml.bank_charge_account_id(@bank_charge_account_id) if @bank_charge_account_id
    xml.bank_charge_account_code(@bank_charge_account_code)  if @bank_charge_account_code
  end
}

