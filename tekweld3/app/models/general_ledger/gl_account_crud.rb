class GeneralLedger::GlAccountCrud
  include General

  def self.list_gl_category(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
    #  GeneralLedger::GlCategory.find_by_code_name_trans_flag(criteria).account_type criteria.str5,criteria.str6
    #  GeneralLedger::GlCategory.find(:all,
    #                                :conditions => ["(code between ? and ? AND (0 =? or code in (?) ) ) AND
    #                                                 (name between ? and ? AND (0 =? or name in (?) ) )   AND
    #                                                 (account_type between ? and ? AND (0 =? or account_type in (?) ) )
    #                                                " ,criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
    #                                               criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2,
    #                                               criteria.str5,criteria.str6,criteria.multiselect3.length,criteria.multiselect3]
    #    )
    GeneralLedger::GlCategory.find_by_sql ["select CAST( (select(select id,
                                                                        code,
                                                                        name,
                                                                        account_type,
                                                                        tb_seq_no,
                                                                        trans_flag
                                                                  from gl_categories
                                                                  where (gl_categories.trans_flag = 'A' OR '#{Setup::TypeCrud.list_all_flag}' = 'Y')
                                                                  AND   (code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or code in ('#{criteria.multiselect1}') ) )
                                                                  AND   (name between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or name in ('#{criteria.multiselect2}') ) )
                                                                  AND   (account_type between '#{criteria.str5}' and '#{criteria.str6}' AND (0 =#{criteria.multiselect3.length} or account_type in ('#{criteria.multiselect2}') ) )
                                          FOR XML PATH('gl_category'),type,elements xsinil)FOR XML PATH('gl_categories')) AS xml) as xmlcol ",
      #                                          criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
      #                                          criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2,
      #                                          criteria.str5,criteria.str6,criteria.multiselect3.length,criteria.multiselect3
    ]
  end

  def self.show_gl_category(gl_id)
    GeneralLedger::GlCategory.find_all_by_id(gl_id)
  end

  def self.create_gl_categories(gl_doc)
    gl_categories = []
    (gl_doc/:gl_categories/:gl_category).each{|doc|
      gl_category = create_gl_category(doc)
      gl_categories <<  gl_category if gl_category
    }
    gl_categories
  end

  def self.create_gl_category(doc)
    gl_category = add_or_modify_category(doc)
    return  if !gl_category
    return gl_category if !gl_category.errors.empty?
    save_proc = Proc.new{
      gl_category.save! 
    }
    gl_category.save_master(&save_proc)
    return  gl_category
  end

  def self.add_or_modify_category(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first
    gl_category = GeneralLedger::GlCategory.find_or_create(id)
    return if !gl_category
    return gl_category if gl_category.view_only
    gl_category.apply_attributes(doc)
    return gl_category
  end

  def self.list_gl_accounts(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    #  GeneralLedger::GlAccount.find_by_code_name_trans_flag(criteria).gl_accounts_only
    # GeneralLedger::GlAccount.find(:all,
    #                                :conditions => ["(code between ? and ? AND (0 =? or code in (?) ) ) AND
    #                                                 (name between ? and ? AND (0 =? or name in (?) ) )
    #                                                " ,criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
    #                                               criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2]                 
    #    )
    GeneralLedger::GlAccount.find_by_sql ["select CAST( (select(select gl_accounts.id,
                                                                       gl_accounts.code,
                                                                       gl_accounts.name,
                                                                       group1,
                                                                       group2,
                                                                       group3,
                                                                       group4,
                                                                       temp_gl.balance,
                                                                       start_date,
                                                                       acct_flag,
                                                                       gl_accounts.trans_flag,
                                                                       gl_categories.code as gl_category_code 
                                                                from gl_accounts
                                                                inner join gl_categories on(gl_categories.id = gl_accounts.gl_category_id)
                                                                left outer join (select gl_accounts.id,sum(gl_summaries.debit_amt - gl_summaries.credit_amt) as balance from gl_accounts
                                                                inner join gl_summaries on gl_summaries.gl_account_id=gl_accounts.id
                                                                group by gl_accounts.id )
                                                                as temp_gl
                                                                on gl_accounts.id=temp_gl.id
                                                                where (gl_accounts.trans_flag = 'A' OR '#{Setup::TypeCrud.list_all_flag}' = 'Y')
                                                                AND   (gl_accounts.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or gl_accounts.code in ('#{criteria.multiselect1}') ) )
                                                                AND   (gl_accounts.name between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or gl_accounts.name in ('#{criteria.multiselect2}') ) )
                                        FOR XML PATH('gl_account'),type,elements xsinil)FOR XML PATH('gl_accounts')) AS xml) as xmlcol ",
      #      criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
      #      criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2
    ]    
  end  

  def self.show_gl_account(gl_id)
    GeneralLedger::GlAccount.find_all_by_id(gl_id)
  end

  def self.create_gl_accounts(gl_doc)
    gl_accounts = []
    (gl_doc/:gl_accounts/:gl_account).each{|doc|
      gl_account = create_gl_account(doc)
      gl_accounts <<  gl_account if gl_account
    }
    gl_accounts
  end

  def self.create_gl_account(doc)
    gl_account = add_or_modify(doc)
    return  if !gl_account
    return gl_account if !gl_account.errors.empty?
    save_proc = Proc.new{
      gl_account.save! 
    }
    gl_account.save_master(&save_proc)
    return  gl_account
  end

  def self.add_or_modify(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first
    gl_account = GeneralLedger::GlAccount.find_or_create(id)
    return if !gl_account
    return gl_account if gl_account.view_only
    gl_account.apply_attributes(doc)
    gl_account.acct_flag = 'A'
    return gl_account
  end
end
