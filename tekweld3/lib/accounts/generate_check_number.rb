module Accounts::GenerateCheckNumber
  include General
  
  def self.generate_check_no_for_bank(trans_type,bank_id)  
    bank =  GeneralLedger::Bank.fetch_bank(bank_id)
    return '' if !bank
    payment_type = bank.payment_type  
    if bank.account_type == 'C'
      return '',payment_type,'N'
    end 
    check_no = generate_check_no(trans_type,bank_id, payment_type)
    return check_no,payment_type,'Y'
  end
  
  def self.generate_check_no(trans_type,bank_id, payment_type)
    bank_check = GeneralLedger::BankCheck.find_first_by_condition("bank_id = ? and payment_type = ?",bank_id, payment_type)
    if bank_check
      check_from = bank_check.check_from 
      check_to = bank_check.check_to 
    end

    check_from ||= '000000' 
    check_to ||= '999999'
    condition="account_id = ? AND
                                   account_flag = 'B' AND
                                   trans_type = ? AND
                                    check_no <> '' AND
                                   trans_date >= '2006-01-01 00:00:00' AND 
                                   check_no between  ? and ? AND
                                   payment_type = ?"
    condition = convert_sql_to_db_specific(condition)
    #  max_check_no = GeneralLedger::BankTransaction.maximum(:check_no,
    #                  :conditions => [condition,bank_id,trans_type,check_from,check_to, payment_type])
    #  check_no = (:check_no.to_i + 1).to_s
    bank_transaction = GeneralLedger::BankTransaction.find_by_sql ["SELECT max(cast(check_no as int)) AS max_check_no FROM bank_transactions where #{condition}",bank_id,trans_type,check_from,check_to, payment_type]
    max_check_no = bank_transaction[0].max_check_no if bank_transaction
    check_no = max_check_no ? (max_check_no.to_i + 1).to_s : 0
    return check_no				
  end


  def self.generate_deposit_slip_no(trans_type,bank_id,trans_date)
    max_deposit_slip_no = GeneralLedger::BankTransaction.maximum(:deposit_no,
      :conditions => ["account_id = ? and 
                                   account_flag = 'B' and
                                   trans_type = ? and
                                   deposit_no <> ''
        ",
        bank_id,trans_type])
  
    deposit_slip_no = GeneralLedger::BankTransaction.maximum(:deposit_no,
      :conditions => ["account_id = ? and 
                                   account_flag = 'B' and
                                   trans_type = ? and
                                   deposit_no <> '' and
                                    trans_date = ?",
        bank_id,trans_type,trans_date])

    max_deposit_slip_no = nulltozero(max_deposit_slip_no)
    deposit_slip_no = nulltozero(deposit_slip_no)
    max_deposit_slip_no =+ 1 if (max_deposit_slip_no.to_i > deposit_slip_no.to_i || deposit_slip_no == 0)
		
    return max_deposit_slip_no
  end

    
end
