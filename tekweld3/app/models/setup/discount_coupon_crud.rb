class Setup::DiscountCouponCrud
  include General

  def self.list_discount_coupons(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "( discount_coupons.company_id = #{criteria.company_id}) AND
                 (discount_coupons.coupon_code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or discount_coupons.coupon_code in ('#{criteria.multiselect1}'))) AND
                 (discount_coupons.customer_code between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or discount_coupons.customer_code in ('#{criteria.multiselect2}'))) AND
                 (discount_coupons.catalog_item_code between '#{criteria.str5}' and '#{criteria.str6}' AND (0 =#{criteria.multiselect3.length} or discount_coupons.catalog_item_code in ('#{criteria.multiselect3}'))) AND
                 (discount_coupons.approval_flag between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or discount_coupons.approval_flag in ('#{criteria.multiselect4}')))
                 AND discount_coupons.trans_flag='A' "
    condition = convert_sql_to_db_specific(condition)
    Setup::DiscountCoupon.find_by_sql ["select CAST( (select(select discount_coupons.*,(users.first_name + ' ' + users.last_name) as created_by_code
                                                      from discount_coupons
                                                      inner join users on users.id = discount_coupons.created_by
                                                      where#{condition}
                                                      FOR XML PATH('discount_coupon'),type,elements xsinil)FOR XML PATH('discount_coupons')) AS xml) as xmlcol"]
  end

  def self.show_discount_coupon(coupon_id)
    Setup::DiscountCoupon.where(:id => coupon_id)
  end

  def self.create_discount_coupons(doc)
    discount_coupons = []
    (doc/:discount_coupons/:discount_coupon).each{|coupon_doc|
      discount_coupon = create_discount_coupon(coupon_doc)
      discount_coupons <<  discount_coupon if discount_coupons
    }
    discount_coupons
  end

  def self.create_discount_coupon(doc)
    coupon = add_or_modify_discount_coupon(doc)
    return if !coupon
    coupon.apply_header_fields_to_lines
    #    coupon.coupon_code = Time.now.strftime('%^a%M%S%3N') + rand(10**4-10).to_s if coupon.new_record?
    coupon.coupon_code = generate_discount_coupon_code(doc) if coupon.new_record?
    email = Email::Email.send_email('DISCOUNTCOUPONAPPROVED',coupon) if coupon.approval_flag == 'Y'
    save_proc = Proc.new{
      if coupon.new_record?
        coupon.save!
      else
        coupon.save!
        coupon.save_lines
      end
      email.save! if email
    }
    coupon.save_transaction(&save_proc)
    return coupon
  end

  def self.add_or_modify_discount_coupon(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first
    coupon = Setup::DiscountCoupon.find_or_create(id)
    return if !coupon
    coupon.apply_attributes(doc)
    coupon.build_lines(doc/:discount_coupon_charges/:discount_coupon_charge)
    coupon
  end

  def self.generate_discount_coupon_code(doc)
    company_id =  parse_xml(doc/'company_id') if (doc/'company_id').first
    sequence_no = generate_docu_no('DC01','DCCODE',company_id)
    account_number = 'TK' + sequence_no if sequence_no
    Setup::Sequence.upd_book_code('DC01','DCCODE',sequence_no,company_id)
    return account_number
  end

  def self.generate_docu_no(book_code,docu_typ,company_id)
    begin
      lno = Setup::Sequence.maximum(:book_lno, :conditions =>[ "book_cd =? and docu_typ = ? and company_id =? and trans_flag = 'A'",book_code, docu_typ,company_id])
      if lno
        lno =lno.to_i + 1
      end
    rescue ActiveRecord::RecordNotFound
      lno = nil
    end
    lno.to_s
  end

  def self.get_coupons_details(doc)
    catalog_item_id = parse_xml(doc/'catalog_item_id')
    customer_id = parse_xml(doc/'customer_id')
    coupon_code = parse_xml(doc/'coupon_code')
    valid_coupons = []
    discount_coupons = Setup::DiscountCoupon.find_by_sql ["select * from discount_coupons where customer_id = '#{customer_id}' and trans_flag = 'A' and id = '#{coupon_code}'
                   and approval_flag = 'Y' and ((no_of_uses - no_of_used) <> 0) and (CONVERT(date,GETDATE(),101) between CONVERT(date,from_date,101) and CONVERT(date,to_date,101))"]
    if discount_coupons[0]
      if !discount_coupons[0].catalog_item_id.blank?
        if (!catalog_item_id.blank? and (discount_coupons[0].catalog_item_id.to_i == catalog_item_id.to_i))
          valid_coupons << discount_coupons[0]
        end
      else
        valid_coupons << discount_coupons[0]
      end
    end
    if valid_coupons[0]
      return valid_coupons,'success'
    else
      return 'Invalid Coupon Code','error'
    end
  end
end
