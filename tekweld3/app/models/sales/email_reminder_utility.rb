class Sales::EmailReminderUtility
  include General
  #  Trans Type Codes
  #  S	Regular Order
  #  E	Re-Order
  #  P	Sample Order
  #  V	Virtual Order
  #  F	Spec Order

  ## Automatic Email Reminder for paper proof. fires daily
  def self.send_email_reminder_for_paper_proof(schema_name,url_with_port)
    pp_date1 = (Time.new.to_date-1).strftime("%Y-%m-%d 23:59:59") #for sending first paperproof reminder
    pp_date2 = (Time.new.to_date-2).strftime("%Y-%m-%d 23:59:59") #for sending second paperproof reminder
    ## for first paper proof reminder
    orders = Sales::SalesOrder.active.find(:all,
      :conditions => ["(sales_orders.hold_order_flag <> 'Y') AND (sales_orders.artworkreviewed_flag = 'Y') AND (sales_orders.artworkapprovedbycust_flag = '') AND
                   (sales_orders.artworksenttocust_flag = 'Y') AND (sales_orders.firstpaperproofreminder = 'N')
                   AND sales_orders.paperproofsenttocust_date <= ? ",pp_date1])
    orders.each{|order|
      order.schema_name=schema_name
      order.url_with_port=url_with_port
      stage_code='FIRSTPAPERPROOFREMINDER'
      email = Email::Email.send_email(stage_code,order)
      order.firstpaperproofreminder = 'Y'
      order.firstpaperproofreminder_date=Time.now
      activity = order.create_sales_order_transaction_activity(stage_code)
      save_proc = Proc.new{
        order.save!
        email.save!
        activity.save!
      }
      order.save_transaction(&save_proc)
    }
    ## for second paper proof reminder
    orders = Sales::SalesOrder.active.find(:all,
      :conditions => ["(sales_orders.hold_order_flag <> 'Y') AND (sales_orders.artworkreviewed_flag = 'Y') AND (sales_orders.artworkapprovedbycust_flag = '') AND
                   (sales_orders.artworksenttocust_flag = 'Y') AND (sales_orders.firstpaperproofreminder = 'Y')
                   AND (sales_orders.secondpaperproofreminder = 'N')
                   AND sales_orders.paperproofsenttocust_date <= ? ",pp_date2])
    orders.each{|order|
      order.schema_name=schema_name
      order.url_with_port=url_with_port
      stage_code='SECONDPAPERPROOFREMINDER'
      email = Email::Email.send_email(stage_code,order)
      order.secondpaperproofreminder = 'Y'
      order.secondpaperproofreminder_date=Time.now
      activity = order.create_sales_order_transaction_activity(stage_code)
      save_proc = Proc.new{
        order.save!
        email.save!
        activity.save!
      }
      order.save_transaction(&save_proc)
    }
  end

  ## Automatic Email Reminder for Unauthorize Credit Card fires daily
  def self.send_email_reminder_for_unauthorized_credit_card(schema_name,url_with_port)
    orders = Sales::SalesOrder.find_by_sql ["select distinct so.*,customers.customer_profile_code from sales_orders so
                                            inner join customers on customers.id = so.customer_id
                                            inner join customer_payment_profiles on customer_payment_profiles.customer_profile_code = customers.customer_profile_code
                                            where
                                            so.trans_flag = 'A' AND
                                            so.term_code = 'CC' AND
                                            so.accountreviewed_flag <> 'Y' AND
                                            so.orderqcstatus_flag = 'Y' AND
                                            so.hold_order_flag <> 'Y' AND
                                            DATALENGTH(customers.customer_profile_code) > 0"]
    orders.each{|order|
      order.schema_name=schema_name
      order.url_with_port=url_with_port
      stage_code='UNAUTHORIZEDCREDITCARDREMINDER'
      email = Email::Email.send_email(stage_code,order)
      activity = order.create_sales_order_transaction_activity(stage_code)
      save_proc = Proc.new{
        order.save!
        email.save!
        activity.save!
      }
      order.save_transaction(&save_proc)
    }
  end


  def self.send_email_reminder_for_rush_orders(schema_name,url_with_port)
    condition = "(sales_orders.artworkreviewed_flag = 'Y') AND (sales_orders.artworkapprovedbycust_flag = '') AND
                   (sales_orders.artworksenttocust_flag = 'Y')
                   AND sales_orders.rushorder_flag = 'Y'
                   AND sales_orders.paper_proof_flag = 'Y'"
    orders = Sales::SalesOrder.active.find(:all,:conditions => condition)
    orders.each{|order|
      order.schema_name=schema_name
      order.url_with_port=url_with_port
      #---for paper proof reminder when 18 hours are left
      if(order.first_rushorder_pp_reminder_flag == 'N' and order.paperproofsenttocust_date.to_datetime.advance(:hours => 6) <= Time.new)
        email = Email::Email.send_email('FIRSTRUSHORDERPROOFREMINDER',order)
        activity = order.create_sales_order_transaction_activity('FIRSTRUSHORDERPROOFREMINDER')
        order.first_rushorder_pp_reminder_flag = 'Y'
        save_proc = Proc.new{
          order.save!
          email.save!
          activity.save!
        }
        order.save_transaction(&save_proc)
      end
      #---for paper proof reminder when 12 hours are left
      if(order.first_rushorder_pp_reminder_flag == 'Y' and order.second_rushorder_pp_reminder_flag == 'N' and order.paperproofsenttocust_date.to_datetime.advance(:hours => 12) <= Time.new)
        email = Email::Email.send_email('SECONDRUSHORDERPROOFREMINDER',order)
        activity = order.create_sales_order_transaction_activity('SECONDRUSHORDERPROOFREMINDER')
        order.second_rushorder_pp_reminder_flag = 'Y'
        save_proc = Proc.new{
          order.save!
          email.save!
          activity.save!
        }
        order.save_transaction(&save_proc)
      end
      #---for paper proof reminder when 6 hours are left
      if(order.second_rushorder_pp_reminder_flag == 'Y' and order.third_rushorder_pp_reminder_flag == 'N' and order.paperproofsenttocust_date.to_datetime.advance(:hours => 18) <= Time.new)
        email = Email::Email.send_email('THIRDRUSHORDERPROOFREMINDER',order)
        activity = order.create_sales_order_transaction_activity('THIRDRUSHORDERPROOFREMINDER')
        order.third_rushorder_pp_reminder_flag = 'Y'
        save_proc = Proc.new{
          order.save!
          email.save!
          activity.save!
        }
        order.save_transaction(&save_proc)
      end
      #---for paper proof reminder when 3 hours are left
      if(order.third_rushorder_pp_reminder_flag == 'Y' and order.fourth_rushorder_pp_reminder_flag == 'N' and order.paperproofsenttocust_date.to_datetime.advance(:hours => 21) <= Time.new)
        email = Email::Email.send_email('FOURTHRUSHORDERPROOFREMINDER',order)
        activity = order.create_sales_order_transaction_activity('FOURTHRUSHORDERPROOFREMINDER')
        order.fourth_rushorder_pp_reminder_flag = 'Y'
        save_proc = Proc.new{
          order.save!
          email.save!
          activity.save!
        }
        order.save_transaction(&save_proc)
      end
      #---for paper proof reminder when 1 hours are left
      if(order.fourth_rushorder_pp_reminder_flag == 'Y' and order.fifth_rushorder_pp_reminder_flag == 'N' and order.paperproofsenttocust_date.to_datetime.advance(:hours => 23) <= Time.new)
        email = Email::Email.send_email('FOURTHRUSHORDERPROOFREMINDER',order)
        activity = order.create_sales_order_transaction_activity('FOURTHRUSHORDERPROOFREMINDER')
        order.fifth_rushorder_pp_reminder_flag = 'Y'
        save_proc = Proc.new{
          order.save!
          email.save!
          activity.save!
        }
        order.save_transaction(&save_proc)
      end
    }
  end
end