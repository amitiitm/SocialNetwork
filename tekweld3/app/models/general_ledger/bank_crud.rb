class GeneralLedger::BankCrud
  include General
  
  #Praman Pal/Vivek Dubey 18 June 2011
  #def self.list_banks(doc)
  #  criteria = Setup::Criteria.fill_criteria(doc/:criteria)
  #  GeneralLedger::Bank.find_by_code_name_trans_flag(criteria).find(:all,
  #                    :conditions=>["( code between ? and ? AND (0 =? or code in (?) ) ) AND
  #                                    ( name between ? and ? AND (0 =? or name in (?) ) ) AND
  #                                    ( bank_acct_no between ? and ? AND (0 =? or bank_acct_no in (?) ) ) AND
  #                                   ( account_type between ? and ? AND (0 =? or account_type in (?) ) )
  #                                     ",
  #                                    criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
  #                                    criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2,
  #                                    criteria.str5,criteria.str6,criteria.multiselect3.length,criteria.multiselect3,
  #                                    criteria.str7[0,2],criteria.str8[0,2],criteria.multiselect4.length,criteria.multiselect4,
  #
  #                                  ])
  #
  #end

  def self.list_banks(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    #  banks=GeneralLedger::Bank.find_by_code_name_trans_flag(criteria).find(:all,
    #    :conditions=>["( code between ? and ? AND (0 =? or code in (?) ) ) AND
    #                                  ( name between ? and ? AND (0 =? or name in (?) ) ) AND
    #                                  ( bank_acct_no between ? and ? AND (0 =? or bank_acct_no in (?) ) ) AND
    #                                 ( account_type between ? and ? AND (0 =? or account_type in (?) ) )
    #      ",
    #      criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
    #      criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2,
    #      criteria.str5,criteria.str6,criteria.multiselect3.length,criteria.multiselect3,
    #      criteria.str7[0,2],criteria.str8[0,2],criteria.multiselect4.length,criteria.multiselect4,
    #
    #    ])
    # banks=GeneralLedger::Bank.find(:all,
    #    :conditions=>["( code between ? and ? AND (0 =? or code in (?) ) ) AND
    #                                  ( name between ? and ? AND (0 =? or name in (?) ) ) AND
    #                                  ( bank_acct_no between ? and ? AND (0 =? or bank_acct_no in (?) ) ) AND
    #                                 ( account_type between ? and ? AND (0 =? or account_type in (?) ) )
    #      ",
    #      criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
    #      criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2,
    #      criteria.str5,criteria.str6,criteria.multiselect3.length,criteria.multiselect3,
    #      criteria.str7[0,2],criteria.str8[0,2],criteria.multiselect4.length,criteria.multiselect4,
    #
    #    ])
    #  banks.each{|bank|
    #    gl_account = bank.gl_account
    #    gl_account_id =  gl_account.id if gl_account
    ##    current_balance = GeneralLedger::GlSummary.find(:all, :select=>'sum(debit_amt - credit_amt) as curr_bal',
    ##      :conditions=> ["gl_account_id = ? and trans_flag = 'A'",
    ##        gl_account_id]).first || 0
    #    current_balance = GeneralLedger::GlSummary.find(:all, :select=>'sum(debit_amt - credit_amt) as curr_bal',
    #    :conditions=> ["gl_account_id = ?",
    #      gl_account_id]).first || 0
    #
    #    bank.current_balance = nulltozero(current_balance['curr_bal'])
    #  }
    banks=GeneralLedger::Bank.find_by_sql ["select CAST( (select(select banks.id,
                                                                      banks.code,
                                                                      banks.name,
                                                                      banks.bank_acct_no,
                                                                      banks.transit_no,
                                                                      banks.contact_nm,
                                                                      banks.city,
                                                                      banks.start_date,
                                                                      banks.account_type,
                                                                      banks.credit_limit,
                                                                      temp_gl.current_balance,
                                                                      banks.trans_flag
                                                            from banks
                                                            inner join gl_accounts on banks.id=gl_accounts.bank_id
                                                            left outer join (select gl_accounts.id,sum(gl_summaries.debit_amt - gl_summaries.credit_amt) as current_balance from gl_accounts
                                                            inner join gl_summaries on gl_summaries.gl_account_id=gl_accounts.id
                                                            group by gl_accounts.id )
                                                            as temp_gl
                                                            on gl_accounts.id=temp_gl.id
                                                            where banks.account_type = 'B' and (banks.trans_flag = 'A' OR '#{Setup::TypeCrud.list_all_flag}' = 'Y')
                                                            AND   (banks.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or banks.code in ('#{criteria.multiselect1}') ) )
                                                            AND   (banks.name between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or banks.name in ('#{criteria.multiselect2}') ) )
                                                            AND   (banks.bank_acct_no between '#{criteria.str5}' and '#{criteria.str6}' AND (0 =#{criteria.multiselect3.length} or banks.bank_acct_no in ('#{criteria.multiselect3}') ) )
                                                           
                                                            FOR XML PATH('bank'),type,elements xsinil)FOR XML PATH('banks')) AS xml) as xmlcol ",
      criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
      criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2,
      criteria.str5,criteria.str6,criteria.multiselect3.length,criteria.multiselect3
    
    ]
    banks
  end

  def self.show_bank(id)
    banks = GeneralLedger::Bank.find_all_by_id(id)
    banks.each{|bank|
      gl_account = bank.gl_account
      gl_account_id =  gl_account.id if gl_account
      current_balance = GeneralLedger::GlSummary.find(:all, :select=>'sum(debit_amt - credit_amt) as curr_bal',
        :conditions=> ["gl_account_id = #{gl_account_id} and trans_flag = 'A'"]).first || 0
                                                                         
      bank.current_balance = nulltozero(current_balance['curr_bal'])
    }
    banks
  end

  # Old (Praman Pal/Vivek Dubey 18 Jun 2011)
  #def self.show_bank(id)
  #  banks = GeneralLedger::Bank.find_all_by_id(id)
  #  banks.each{|bank|
  #    gl_account = bank.gl_account
  #    gl_account_id =  gl_account.id if gl_account
  #    current_balance = GeneralLedger::BankTransaction.find(:all, :select=>'sum(debit_amt - credit_amt) as curr_bal',
  #                                                              :conditions=> ["bank_id = ? and trans_flag = 'A'",
  #                                                                              gl_account_id]).first || 0
  #
  #    bank.current_balance = nulltozero(current_balance['curr_bal'])
  # }
  # banks
  #end

  def self.create_banks(gl_doc)
    banks = []
    (gl_doc/:banks/:bank).each{|doc|
      bank = create_bank(doc)
      banks <<  bank if bank
    }
    banks
  end

  def self.create_bank(doc)
    bank = add_or_modify(doc)
    return  if !bank
    return bank if !bank.errors.empty?
    save_proc = Proc.new{
      if bank.new_record?
        # previously done
        # bank.save!
        #
      
        # new code by praman
        bank.gl_account.save! if bank.gl_account
        bank.id = bank.gl_account.id
        bank.save!
        #
      else
        bank.save!
        bank.bank_checks.save_line
        bank.gl_account.save! if bank.gl_account
      end
    
    }
    bank.save_transaction(&save_proc)
    return bank
  end

  def self.add_or_modify(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first
    bank = GeneralLedger::Bank.find_or_create(id)
    return if !bank
    return bank if bank.view_only
    bank.apply_attributes(doc)
    if bank.new_record?
      bank.create_new_gl_account
    else
      (gl_account = bank.gl_account) ?  gl_account.fill_gl_account(bank.attributes) :  bank.create_new_gl_account
    end
    bank.build_lines(doc/:bank_checks/:bank_check)
    return bank
  end



end
