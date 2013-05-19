ruby script/runner -e development "require 'action_controller/integration';app = ActionController::Integration::Session.new; app.get 'http://tekweld.promo:3000/email/email_reminder/send_email_reminder_for_unauthorized_credit_card'"

