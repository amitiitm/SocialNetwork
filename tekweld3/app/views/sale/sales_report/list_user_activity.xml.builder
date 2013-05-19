xml.instruct! :xml, :version=>"1.0"
if @orders
  xml.sales_orders{
    for sales_order in @orders
      xml.sales_order do
        xml.trans_no(sales_order[:trans_no])
        xml.order_created_user_name(sales_order[:order_created_user_name])
        xml.order_created_time(sales_order[:order_created_time])
        xml.order_assigned_user_name(sales_order[:order_assigned_user_name])
        xml.order_assigned_time_diff(sales_order[:order_assigned_time_diff])
        xml.order_entry_user_name(sales_order[:order_entry_user_name])
        xml.order_entry_time_diff(sales_order[:order_entry_time_diff])
        xml.order_qc_user_name(sales_order[:order_qc_user_name])
        xml.order_qc_time_diff(sales_order[:order_qc_time_diff])
        xml.order_account_user_name(sales_order[:order_account_user_name])
        xml.order_account_time_diff(sales_order[:order_account_time_diff])
        xml.artwork_assigned_user_name(sales_order[:artwork_assigned_user_name])
        xml.artwork_assigned_time_diff(sales_order[:artwork_assigned_time_diff])
        xml.artwork_completed_user_name(sales_order[:artwork_completed_user_name])
        xml.artwork_completed_time_diff(sales_order[:artwork_completed_time_diff])
        xml.artwork_reviewed_user_name(sales_order[:artwork_reviewed_user_name])
        xml.artwork_reviewed_time_diff(sales_order[:artwork_reviewed_time_diff])
      end
    end
  }
end




#xml.instruct! :xml, :version=>"1.0"
#
#xml.sales_orders{
#  for sales_order in @orders
#    xml.sales_order do
#      xml.trans_no(sales_order.trans_no)
#      entry_time=''
#      qc_time=''
#      account_time=''
#      assigne_time=''
#      for sales_order_transaction_activity in sales_order.sales_order_transaction_activities
#        if sales_order_transaction_activity.trans_flag == 'A'
#          if sales_order_transaction_activity.sales_order_stage_code == 'NEW ORDER'
#            user = Admin::User.find_by_sql("select first_name,last_name from users where id = #{sales_order_transaction_activity.user_id}") if sales_order_transaction_activity.user_id
#            xml.order_created_user_name(user.first.first_name) if user.first
#
#            datetime = find_datetime_difference(Time.now,sales_order_transaction_activity.activity_date)
#            xml.order_created_time(datetime[:diff])
#            #            xml.order_created_time(sales_order_transaction_activity.activity_date.strftime("%H:%m:%S"))
#          end
#          if sales_order_transaction_activity.sales_order_stage_code == 'ORDER PICKED'
#
#            assigne_time=sales_order_transaction_activity.activity_date if assigne_time ==''
#            assigne_user_id=sales_order_transaction_activity.user_id
#            if assigne_time < sales_order_transaction_activity.activity_date
#              assigne_user_id=sales_order_transaction_activity.user_id
#              assigne_time=sales_order_transaction_activity.activity_date
#
#            end
#            previous_activity = Sales::SalesOrderTransactionActivity.find_by_trans_no_and_sales_order_stage_code(sales_order.trans_no,'NEW')
#            if previous_activity
#              datetime = find_datetime_difference(sales_order_transaction_activity.activity_date,previous_activity.activity_date)
#              xml.order_assigned_time_diff(datetime[:diff])
#            end
#          end
#          if sales_order_transaction_activity.sales_order_stage_code == 'ENTRY COMPLETED'
#            entry_time=sales_order_transaction_activity.activity_date if entry_time==''
#            entry_user_id=sales_order_transaction_activity.user_id
#            if entry_time < sales_order_transaction_activity.activity_date
#
#              entry_user_id=sales_order_transaction_activity.user_id
#              entry_time=sales_order_transaction_activity.activity_date
#            end
#            previous_activity = Sales::SalesOrderTransactionActivity.find_by_trans_no_and_sales_order_stage_code(sales_order.trans_no,'ORDER ASSIGNED')
#            if previous_activity
#              datetime = find_datetime_difference(sales_order_transaction_activity.activity_date,previous_activity.activity_date)
#              xml.order_entry_time_diff(datetime[:diff])
#            end
#          end
#          if sales_order_transaction_activity.sales_order_stage_code == 'QC COMPLETE'
#            qc_time=sales_order_transaction_activity.activity_date if qc_time ==''
#            qc_user_id=sales_order_transaction_activity.user_id
#            if qc_time < sales_order_transaction_activity.activity_date
#              qc_user_id=sales_order_transaction_activity.user_id
#              qc_time=sales_order_transaction_activity.activity_date
#
#            end
#            previous_activity = Sales::SalesOrderTransactionActivity.find_by_trans_no_and_sales_order_stage_code(sales_order.trans_no,'ORDER ENTRY COMPLETED')
#            if previous_activity
#              datetime = find_datetime_difference(sales_order_transaction_activity.activity_date,previous_activity.activity_date)
#              xml.order_qc_time_diff(datetime[:diff])
#            end
#          end
#          if sales_order_transaction_activity.sales_order_stage_code == 'CLEARED FROM ACCOUNTS DEPT'
#            account_time=sales_order_transaction_activity.activity_date if account_time == ''
#            account_user_id=sales_order_transaction_activity.user_id
#
#            if account_time.to_date < sales_order_transaction_activity.activity_date.to_date
#              account_user_id=sales_order_transaction_activity.user_id
#              account_time=sales_order_transaction_activity.activity_date
#
#            end
#            previous_activity = Sales::SalesOrderTransactionActivity.find_by_trans_no_and_sales_order_stage_code(sales_order.trans_no,'QUALITY CHECKED')
#            if previous_activity
#              datetime = find_datetime_difference(sales_order_transaction_activity.activity_date,previous_activity.activity_date)
#              xml.order_account_time_diff(datetime[:diff])
#            end
#          end
#          if sales_order_transaction_activity.sales_order_stage_code == 'PROOF IN PROGRESS'
#            user = Admin::User.find_by_sql("select first_name,last_name from users where id = #{sales_order_transaction_activity.user_id}") if sales_order_transaction_activity.user_id
#            xml.artwork_assigned_user_name(user.first.first_name) if user.first
#            previous_activity = Sales::SalesOrderTransactionActivity.find_by_trans_no_and_sales_order_stage_code(sales_order.trans_no,'ARTWORK RECEIVED')
#            if previous_activity
#              datetime = find_datetime_difference(sales_order_transaction_activity.activity_date,previous_activity.activity_date)
#              xml.artwork_assigned_time_diff(datetime[:diff])
#            end
#          end
#          if sales_order_transaction_activity.sales_order_stage_code == 'READY FOR INTERNAL PROOFING'
#            user = Admin::User.find_by_sql("select first_name,last_name from users where id = #{sales_order_transaction_activity.user_id}") if sales_order_transaction_activity.user_id
#            xml.artwork_completed_user_name(user.first.first_name) if user.first
#            previous_activity = Sales::SalesOrderTransactionActivity.find_by_trans_no_and_sales_order_stage_code(sales_order.trans_no,'ARTWORK IN PROGRESS')
#            if previous_activity
#              datetime = find_datetime_difference(sales_order_transaction_activity.activity_date,previous_activity.activity_date)
#              xml.artwork_completed_time_diff(datetime[:diff])
#            end
#          end
#          if sales_order_transaction_activity.sales_order_stage_code == 'ARTWORK QC'
#
#            review_time=sales_order_transaction_activity.activity_date
#            review_user_id=sales_order_transaction_activity.user_id
#            if review_time < sales_order_transaction_activity.activity_date
#              review_user_id=sales_order_transaction_activity.user_id
#              review_time=sales_order_transaction_activity.activity_date
#            end
#            previous_activity = Sales::SalesOrderTransactionActivity.find_by_trans_no_and_sales_order_stage_code(sales_order.trans_no,'READY FOR INTERNAL PROOFING')
#            if previous_activity
#              datetime = find_datetime_difference(sales_order_transaction_activity.activity_date,previous_activity.activity_date)
#              xml.artwork_reviewed_time_diff(datetime[:diff])
#            end
#          end
#        end
#      end
#      user = Admin::User.find_by_sql("select first_name,last_name from users where id = #{entry_user_id.to_i}") if sales_order_transaction_activity.user_id
#      xml.order_entry_user_name(user.first.first_name) if user.first
#
#      user = Admin::User.find_by_sql("select first_name,last_name from users where id = #{qc_user_id.to_i}") if sales_order_transaction_activity.user_id
#      xml.order_qc_user_name(user.first.first_name) if user.first
#      user = Admin::User.find_by_sql("select first_name,last_name from users where id = #{review_user_id.to_i}") if sales_order_transaction_activity.user_id
#      xml.artwork_reviewed_user_name(user.first.first_name) if user.first
#
#      user = Admin::User.find_by_sql("select first_name,last_name from users where id = #{account_user_id.to_i}") if sales_order_transaction_activity.user_id
#      xml.order_account_user_name(user.first.first_name) if user.first
#
#      user = Admin::User.find_by_sql("select first_name,last_name from users where id = #{assigne_user_id.to_i}") if sales_order_transaction_activity.user_id
#      xml.order_assigned_user_name(user.first.first_name) if user.first
#    end
#  end
#}