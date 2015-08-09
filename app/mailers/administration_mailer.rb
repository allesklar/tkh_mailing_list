class AdministrationMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  default :from => "#{Setting.first.try(:company_name)} <#{Setting.first.try(:contact_email)}>"

  # this job is called by the Administration model in this gem
  def daily_digest( admin_user, yesterdays_contact_messages, pending_comments, yesterdays_activities )
    @recipient = admin_user
    @contact_messages = yesterdays_contact_messages
    @pending_comments = pending_comments
    @yesterdays_activities = yesterdays_activities
    # FIXME - only the email addresses show up. not the names :-(
    recipient = "#{@recipient.name} <#{@recipient.email}>"
    reply_to = "#{Setting.first.try(:company_name)} <#{Setting.first.try(:contact_email)}>"
    mail  to: recipient,
          reply_to: reply_to,
          subject: "#{t('admin.mailer.daily_digest.subject')}- #{l Time.zone.now.to_date}" do |format|
      format.html { render layout: 'admin_mailers.html.erb' }
      format.text
    end
  end

end
