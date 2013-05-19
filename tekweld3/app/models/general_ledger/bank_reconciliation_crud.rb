class GeneralLedger::BankReconciliationCrud
  include General

  def self.fetch_bank_transaction_details(doc)
    beginning_amt, outstanding_amt, amt = calculate_bank_amounts(parse_xml(doc/'bank_id'), parse_xml(doc/'from_date'), parse_xml(doc/'to_date'), parse_xml(doc/'account_period_code'), parse_xml(doc/'company_id'))

    GeneralLedger::Bank.find_by_sql(
      "SELECT
          (
          SELECT  #{(amt.deposit.to_f + amt.payment.to_f + beginning_amt.to_f)} as ending_amt,
                  #{beginning_amt} as begining_amt,
                  #{amt.deposit} as deposit_amt,
                  #{amt.payment} as payment_amt,
                  #{outstanding_amt.payment} as outstanding_payment_amt,
                  #{outstanding_amt.deposit} as outstanding_deposit_amt,
                  #{outstanding_amt.payment.to_f + outstanding_amt.deposit.to_f + amt.deposit.to_f + amt.payment.to_f + beginning_amt.to_f} as bank_amt,
                  0 AS bank_balance,
                  #{bank_transactions_fetch_subquery}
          FOR XML PATH('row'), TYPE
          ) AS xmlcol
       FROM (SELECT #{parse_xml(doc/'bank_id').to_i} AS bank_id, '#{parse_xml(doc/'from_date').to_date.strftime("%Y-%m-%d")}' AS from_date, '#{parse_xml(doc/'to_date').to_date.strftime("%Y-%m-%d")}' AS to_date, '#{parse_xml(doc/'account_period_code')}' AS account_period_code)criteria")
  end

  def self.create_bank_reconciliations(doc)
    bank_reconciliations = []
    (doc/:bank_reconciliations/:bank_reconciliation).each{|re_doc|
      bank_reconciliation = create_bank_reconciliation(re_doc)
      bank_reconciliations <<  bank_reconciliation if bank_reconciliation
    }
    bank_reconciliations
  end

  def self.create_bank_reconciliation(doc)
    bank_reconciliation = add_or_modify_bank_reconciliation(doc)
    return  if !bank_reconciliation
    return bank_reconciliation if !bank_reconciliation.errors.empty?
    save_proc = Proc.new{
      (doc/:bank_transactions/:bank_transaction).each{|line_doc|
        update_bank_transaction_details(line_doc).save!
      }
      bank_reconciliation.save!
    }
    bank_reconciliation.save_transaction(&save_proc)
    return bank_reconciliation
  end

  def self.add_or_modify_bank_reconciliation(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first
    bank_reconciliation = GeneralLedger::BankReconciliation.find_or_create(id)
    return if !bank_reconciliation
    return bank_reconciliation if bank_reconciliation.view_only
    bank_reconciliation.apply_attributes(doc)
    bank_reconciliation.trans_flag = 'A' if(bank_reconciliation.trans_flag.to_s == '')
    return bank_reconciliation
  end

  def self.update_bank_transaction_details(line_doc) #for bank_reconciliation
    id =  parse_xml(line_doc/'id') if (line_doc/'id').first
    bank_transaction = GeneralLedger::BankTransaction.find(id)
    if(bank_transaction)
      trans_type = bank_transaction.trans_type
      bank_transaction.apply_attributes(line_doc)
      bank_transaction.trans_type =  trans_type
      GeneralLedger::BankTransaction.find_all_by_trans_bk_and_trans_no_and_trans_date(bank_transaction.trans_bk,bank_transaction.trans_no,bank_transaction.trans_date).each{|bank_transaction_update|
        bank_transaction_update.update_attributes({'clear_flag' =>bank_transaction.clear_flag,  'clear_date' => bank_transaction.clear_date }) if(bank_transaction.id != bank_transaction_update.id)
      }
      if( bank_transaction.clear_flag == 'Y')
        bank_transaction.update_flag = 'V'
        GeneralLedger::BankTransaction.find_all_by_trans_bk_and_trans_no_and_trans_date(bank_transaction.trans_bk,bank_transaction.trans_no,bank_transaction.trans_date).each{|bank_transaction_update|
          bank_transaction_update.update_attributes({'update_flag' => 'V'}) if(bank_transaction.id != bank_transaction_update.id)
        }
        for gl_detail in GeneralLedger::GlDetail.find_all_by_trans_bk_and_trans_no_and_trans_date(bank_transaction.trans_bk,bank_transaction.trans_no,bank_transaction.trans_date)
          gl_detail.update_attributes({'update_flag' => 'V'})
        end
        for customer_receipt in Customer::CustomerReceipt.find_all_by_trans_bk_and_trans_no_and_trans_date(bank_transaction.trans_bk,bank_transaction.trans_no,bank_transaction.trans_date)
          customer_receipt.update_attributes({'update_flag' => 'V'})
        end if(bank_transaction.trans_type == 'DEPS' or bank_transaction.credit_amt > 0)
        for vendor_payment in Vendor::VendorPayment.find_all_by_trans_bk_and_trans_no_and_trans_date(bank_transaction.trans_bk,bank_transaction.trans_no,bank_transaction.trans_date)
          vendor_payment.update_attributes({'update_flag' => 'V'})
        end if(bank_transaction.trans_type == 'PAYM' or bank_transaction.debit_amt > 0)
      end
    end
    return bank_transaction
  end

  def self.show_bank_reconciliation(bank_reconciliations)
    ids = ''
    if(bank_reconciliations.class == Array)
      for bank_recociliation in bank_reconciliations
        ids += bank_recociliation.id.to_s + ","
      end
      ids.chop!
    else
      ids = bank_reconciliations
    end

    GeneralLedger::BankReconciliation.find_by_sql(
      "SELECT CAST((
                  SELECT (
                          SELECT  *
                          FROM (
                                  SELECT (
                                          SELECT  criteria.id,
                                                  criteria.update_flag,
                                                  criteria.updated_at,
                                                  criteria.from_date,
                                                  criteria.to_date,
                                                  criteria.account_period_code,
                                                  criteria.bank_id,
                                                  criteria.bank_code,
                                                  lock_version,
                                                  ISNULL(bank_balance, 0) AS bank_balance,
                                                  ISNULL(begining_amt, 0) AS begining_amt,
                                                  ISNULL(deposit_amt, 0) AS deposit_amt,
                                                  ISNULL(payment_amt, 0) AS payment_amt,
                                                  ISNULL(outstanding_deposit_amt, 0) AS outstanding_deposit_amt,
                                                  ISNULL(outstanding_payment_amt, 0) AS outstanding_payment_amt,
                                                  (ISNULL(begining_amt, 0) + ISNULL(deposit_amt, 0) + ISNULL(payment_amt, 0)) AS ending_amt,
                                                  (ISNULL(begining_amt, 0) + ISNULL(deposit_amt, 0) + ISNULL(payment_amt, 0) + ISNULL(outstanding_deposit_amt, 0) + ISNULL(outstanding_payment_amt, 0)) AS bank_amt,
                                                  #{bank_transactions_fetch_subquery}
                                          FOR XML PATH(''), TYPE ,ELEMENTS XSINIL
                                         ) AS bank_reconciliation
                                  FROM (
                                        SELECT  *,
                                                (
                                                  SELECT ISNULL(SUM(ISNULL(credit_amt, 0) - ISNULL(debit_amt, 0)), 0) AS amt
                                                  FROM bank_transactions
                                                  WHERE bank_id = bank_reco.bank_id
                                                  AND   account_period_code <= bank_reco.account_period_code
                                                  AND   trans_date <= bank_reco.from_date
                                                  AND   company_id = 1
                                                  AND   trans_flag = 'A'
                                                  AND   (((trans_type = 'DEPS' OR trans_type='PAYM') AND account_flag <> 'B') OR trans_type = 'TRFR')
                                                ) AS begining_amt,
                                                (
                                                  SELECT  ISNULL(SUM(ISNULL(credit_amt, 0)), 0)
                                                  FROM	bank_transactions
                                                  WHERE   bank_id = bank_reco.bank_id
                                                  AND     account_period_code <= bank_reco.account_period_code
                                                  AND     trans_date BETWEEN bank_reco.from_date AND bank_reco.to_date
                                                  AND     company_id = 1
                                                  AND     trans_flag = 'A'
                                                  AND     (((trans_type = 'DEPS' OR trans_type='PAYM') AND account_flag <> 'B') OR trans_type = 'TRFR')
                                                ) AS deposit_amt,
                                                (
                                                  SELECT  ISNULL(SUM(ISNULL(debit_amt, 0)), 0) * -1
                                                  FROM	bank_transactions
                                                  WHERE   bank_id = bank_reco.bank_id
                                                  AND     account_period_code <= bank_reco.account_period_code
                                                  AND     trans_date BETWEEN bank_reco.from_date AND bank_reco.to_date
                                                  AND     company_id = 1
                                                  AND     trans_flag = 'A'
                                                  AND     (((trans_type = 'DEPS' OR trans_type='PAYM') AND account_flag <> 'B') OR trans_type = 'TRFR')
                                                ) AS payment_amt,
                                                (
                                                  SELECT  ISNULL(SUM(ISNULL(debit_amt, 0)), 0)
                                                  FROM  bank_transactions
                                                  WHERE	bank_id = bank_reco.bank_id
                                                  AND	account_period_code <= bank_reco.account_period_code
                                                  AND	trans_date <= bank_reco.to_date
                                                  AND 	clear_flag <> 'Y'
                                                  AND	trans_flag = 'A'
                                                  AND     (((trans_type = 'DEPS' OR trans_type='PAYM') AND account_flag <> 'B') OR trans_type = 'TRFR')
                                                )AS outstanding_payment_amt,
                                                (
                                                  SELECT  ISNULL(SUM(ISNULL(credit_amt, 0)), 0) * -1
                                                  FROM  bank_transactions
                                                  WHERE	bank_id = bank_reco.bank_id
                                                  AND	account_period_code <= bank_reco.account_period_code
                                                  AND	trans_date <= bank_reco.to_date
                                                  AND 	clear_flag <> 'Y'
                                                  AND	trans_flag = 'A'
                                                  AND     (((trans_type = 'DEPS' OR trans_type='PAYM') AND account_flag <> 'B') OR trans_type = 'TRFR')
                                                )AS outstanding_deposit_amt
                                        FROM bank_reconciliations bank_reco
                                        WHERE id IN(#{ids})
                                      )criteria
                                   )bank_reco FOR XML PATH(''), TYPE, ELEMENTS XSINIL
                            )FOR XML PATH('bank_reconciliations')
                      )AS XML)AS xmlcol")[0].xmlcol
  end

  def self.list_bank_reconciliation(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    GeneralLedger::BankReconciliation.find_by_sql(
      "SELECT CAST((
                      SELECT (
                                SELECT  id,
                                        bank_code,
                                        from_date,
                                        to_date,
                                        account_period_code,
                                        bank_balance
                                FROM bank_reconciliations
                                WHERE (bank_reconciliations.trans_flag = 'A' OR '#{Setup::TypeCrud.list_all_flag}' = 'Y')
                                AND   (bank_code BETWEEN '#{criteria.str1}' AND '#{criteria.str2}' AND (0 = #{criteria.multiselect1.length} OR bank_reconciliations.bank_code in ('#{criteria.multiselect1}')))
                                AND   from_date BETWEEN '#{criteria.dt1.to_date.strftime("%Y-%m-%d")}' AND '#{criteria.dt2.to_date.strftime("%Y-%m-%d")}'
                                AND   to_date BETWEEN '#{criteria.dt3.to_date.strftime("%Y-%m-%d")}' AND '#{criteria.dt4.to_date.strftime("%Y-%m-%d")}'
                                AND   (account_period_code BETWEEN '#{criteria.str3}' AND '#{criteria.str4}' AND (0 = #{criteria.multiselect2.length} OR bank_reconciliations.account_period_code in ('#{criteria.multiselect2}')))
                                FOR XML PATH('bank_reconciliation'), TYPE, ELEMENTS XSINIL
                              )FOR XML PATH('bank_reconciliations')
                      ) AS XML)xmlcol")
  end

  def self.calculate_bank_amounts(bank_id, from_date, to_date, account_period_code, company_id)
    beginning_amt = GeneralLedger::Bank.find_by_sql(" SELECT ISNULL(SUM(ISNULL(credit_amt, 0) - ISNULL(debit_amt, 0)), 0) AS amt
                                                      FROM bank_transactions
                                                      WHERE bank_id = #{bank_id}
                                                      AND   account_period_code <= '#{account_period_code}'
                                                      AND   trans_date <= '#{from_date}'
                                                      AND   company_id = '#{company_id}'
                                                      AND   trans_flag = 'A'
                                                      AND   (((trans_type = 'DEPS' OR trans_type='PAYM') AND account_flag <> 'B') OR trans_type = 'TRFR')
      ")[0]
    beginning_amt = beginning_amt ? beginning_amt.amt : 0

    outstanding_amt = GeneralLedger::Bank.find_by_sql(" SELECT  ISNULL(SUM(ISNULL(debit_amt, 0)), 0) AS payment, ISNULL(SUM(ISNULL(credit_amt, 0)), 0) * -1 AS deposit
                                                        FROM  bank_transactions
                                                        WHERE	bank_id = #{bank_id}
                                                        AND	account_period_code <= '#{account_period_code}'
                                                        AND	trans_date <= '#{to_date}'
                                                        AND 	clear_flag <> 'Y'
                                                        AND	trans_flag = 'A'
                                                        AND     (((trans_type = 'DEPS' OR trans_type='PAYM') AND account_flag <> 'B') OR trans_type = 'TRFR')
      " )[0]

    amt = GeneralLedger::Bank.find_by_sql("SELECT   ISNULL(SUM(ISNULL(credit_amt, 0)), 0) AS deposit, ISNULL(SUM(ISNULL(debit_amt, 0)), 0) * -1 AS payment
                                          FROM	bank_transactions
                                          WHERE   bank_id = #{bank_id}
                                          AND     account_period_code <= '#{account_period_code}'
                                          AND     trans_date BETWEEN '#{from_date}' AND '#{to_date}'
                                          AND     company_id = '#{company_id}'
                                          AND     trans_flag = 'A'
                                          AND     (((trans_type = 'DEPS' OR trans_type='PAYM') AND account_flag <> 'B') OR trans_type = 'TRFR')
      ")[0]

    return beginning_amt, outstanding_amt, amt
  end

  def self.bank_transactions_fetch_subquery
    return "
    (
      SELECT (
                SELECT  id,
                        trans_no,
                        trans_date,
                        CASE
                          WHEN ISNULL(credit_amt, 0) > 0 THEN 'DEPS'
                          ELSE 'PAYM'
                        END AS trans_type,
                        clear_flag,
                        clear_date,
                        bank_id,
                        bank_code,
                        account_id,
                        account_code,
                        deposit_no,
                        credit_amt,
                        debit_amt,
                        serial_no,
                        check_no,
                        check_date,
                        payto_name,
                        remarks
                FROM bank_transactions
                WHERE   bank_id = criteria.bank_id
                AND     account_period_code <= criteria.account_period_code
                AND     ((trans_date <= criteria.to_date AND ISNULL(clear_flag, 'N') <> 'Y') OR (trans_date between criteria.from_date AND criteria.to_date AND ISNULL(clear_flag, 'N') = 'Y'))
                AND     trans_flag = 'A'
                AND     (ISNULL(credit_amt, 0) > 0 OR ISNULL(debit_amt, 0) > 0)
                AND     (((trans_type = 'DEPS' OR trans_type='PAYM') AND account_flag <> 'B') OR trans_type = 'TRFR')
                FOR XML PATH('bank_transaction'), ELEMENTS XSINIL, TYPE
             )
      FOR XML PATH('bank_transactions'), TYPE
    ),
    (
    SELECT (
                SELECT  id,
                        trans_no,
                        trans_date,
                        'DEPS' AS trans_type,
                        clear_flag,
                        clear_date,
                        bank_id,
                        bank_code,
                        account_id,
                        account_code,
                        deposit_no,
                        credit_amt,
                        debit_amt,
                        serial_no,
                        check_no,
                        check_date,
                        payto_name,
                        remarks
                FROM bank_transactions
                WHERE   bank_id = criteria.bank_id
                AND     account_period_code <= criteria.account_period_code
                AND     ((trans_date <= criteria.to_date AND ISNULL(clear_flag, 'N') <> 'Y') OR (trans_date between criteria.from_date AND criteria.to_date AND ISNULL(clear_flag, 'N') = 'Y'))
                AND     (((trans_type = 'DEPS' OR trans_type='PAYM') AND account_flag <> 'B') OR trans_type = 'TRFR')
                AND     ISNULL(credit_amt, 0) > 0
                AND     trans_flag='A'
                FOR XML PATH('bank_deposit_transaction'), ELEMENTS XSINIL, TYPE
           )
    FOR XML PATH('bank_deposit_transactions'), TYPE
    ),
    (
    SELECT (
                SELECT  id,
                        trans_no,
                        trans_date,
                        'PAYM' AS trans_type,
                        clear_flag,
                        clear_date,
                        bank_id,
                        bank_code,
                        account_id,
                        account_code,
                        deposit_no,
                        credit_amt,
                        debit_amt,
                        serial_no,
                        check_no,
                        check_date,
                        payto_name,
                        remarks
                FROM bank_transactions
                WHERE   bank_id = criteria.bank_id
                AND     account_period_code <= criteria.account_period_code
                AND     ((trans_date <= criteria.to_date AND ISNULL(clear_flag, 'N') <> 'Y') OR (trans_date between criteria.from_date AND criteria.to_date AND ISNULL(clear_flag, 'N') = 'Y'))
                AND     ISNULL(debit_amt, 0) > 0
                AND     (((trans_type = 'DEPS' OR trans_type='PAYM') AND account_flag <> 'B') OR trans_type = 'TRFR')
                AND     trans_flag='A'
                FOR XML PATH('bank_payment_transaction'), ELEMENTS XSINIL, TYPE
           )
    FOR XML PATH('bank_payment_transactions'), TYPE
    ),
    (
    SELECT (
                SELECT  id,
                        trans_no,
                        trans_date,
                        CASE
                          WHEN ISNULL(credit_amt, 0) > 0 THEN 'DEPS'
                          ELSE 'PAYM'
                        END AS trans_type,
                        clear_flag,
                        clear_date,
                        bank_id,
                        bank_code,
                        account_id,
                        account_code,
                        deposit_no,
                        credit_amt,
                        debit_amt,
                        serial_no,
                        check_no,
                        check_date,
                        payto_name,
                        remarks
                FROM bank_transactions
                WHERE   bank_id = criteria.bank_id
                AND     account_period_code <= criteria.account_period_code
                AND     trans_date between criteria.from_date AND criteria.to_date
                AND     clear_flag = 'Y'
                AND     trans_flag = 'A'
                AND     (((trans_type = 'DEPS' OR trans_type='PAYM') AND account_flag <> 'B') OR trans_type = 'TRFR')
                FOR XML PATH('bank_cleared_transaction'), ELEMENTS XSINIL, TYPE
           )
    FOR XML PATH('bank_cleared_transactions'), TYPE
    )"
  end
end