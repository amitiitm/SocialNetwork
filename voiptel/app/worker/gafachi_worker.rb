class GafachiWorker < Workling::Base 
  def retrive_report(options)
    a = WWW::Mechanize.new do |agent|
      agent.follow_meta_refresh = true
    end
    # open gafachi
    page = a.get("http://gafachi.com/")
    login_form = page.forms[0]
    # filling out the form
    login_form.LOGIN_USERNAME = "openfo1"
    login_form.LOGIN_PASSWORD = "Farhad1234"

    page = a.submit(login_form, login_form.buttons.first)
    page = a.click page.links.text('Call Details (CDRs)')

    form = page.forms.first
    form.REPORT_FORMAT = "3"
    form.REPORT_MIN_YEAR = "2008"
    form.REPORT_MIN_MONTH = "9"
    form.REPORT_MIN_DAY = "10"

    form.REPORT_MAX_YEAR = "2008"
    form.REPORT_MAX_MONTH = "9"
    form.REPORT_MAX_DAY = "15"

    page = a.submit(form, form.buttons.first)

    page = a.click page.links.first
    Rails.cache.write('result', page.body)
  end
end