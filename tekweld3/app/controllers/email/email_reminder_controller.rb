class Email::EmailReminderController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods

  ## Automatic Reminder For PaperProof
  def send_email_reminder_for_paper_proof
    url_with_port = request.host_with_port
    request_array = url_with_port.split(".")
    company_code = request_array[0]
    company = Setup::Company.find_by_sql ["select schema_name from main.dbo.main_companies where code=?",company_code]#  if ActiveRecord::Base.retrieve_connection.class.to_s.match('SQLServerAdapter')
    schema_name = company.first.schema_name
    Sales::EmailReminderUtility.send_email_reminder_for_paper_proof(schema_name,url_with_port)
    render :text=>'Reminder sent Successfully'
  end

  ## Automatic Reminder For unauthorized credit card runs only once a day.
  def send_email_reminder_for_unauthorized_credit_card
    url_with_port = request.host_with_port
    request_array = url_with_port.split(".")
    company_code = request_array[0]
    company = Setup::Company.find_by_sql ["select schema_name from main.dbo.main_companies where code=?",company_code] #if ActiveRecord::Base.retrieve_connection.class.to_s.match('SQLServerAdapter')
    schema_name = company.first.schema_name
    Sales::EmailReminderUtility.send_email_reminder_for_unauthorized_credit_card(schema_name,url_with_port)
    render :text=>'Reminder sent Successfully'
  end

  def send_email_reminder_for_rush_orders
    url_with_port = request.host_with_port
    request_array = url_with_port.split(".")
    company_code = request_array[0]
    company = Setup::Company.find_by_sql ["select schema_name from main.dbo.main_companies where code=?",company_code] #if ActiveRecord::Base.retrieve_connection.class.to_s.match('SQLServerAdapter')
    schema_name = company.first.schema_name
    Sales::EmailReminderUtility.send_email_reminder_for_rush_orders(schema_name,url_with_port)
    render :text=>'Reminder sent Successfully'
  end
end
