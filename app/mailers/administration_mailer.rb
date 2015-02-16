class AdministrationMailer < ActionMailer::Base

  default :from => "#{Setting.first.try(:company_name)} <#{Setting.first.try(:contact_email)}>"

  def daily_digest( admin_user, yesterdays_contact_messages )
    @recipient = admin_user
    @contact_messages = yesterdays_contact_messages
    # FIXME - only the email addresses show up. not the names :-(
    recipient = "#{@recipient.name} <#{@recipient.email}>"
    reply_to = "#{Setting.first.try(:company_name)} <#{Setting.first.try(:contact_email)}>"
    mail  to: recipient,
          reply_to: reply_to,
          subject: "#{t('admin.mailer.daily_digest.subject')}- #{l Time.zone.now.to_date}"
  end

end
