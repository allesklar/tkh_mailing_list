class EnewsMailer < ActionMailer::Base
  include Roadie::Rails::Automatic
  default from: "La Source <info@yoga.lu>"

  def newsletter(user, mailing)
    @user = user
    @mailing = mailing
    subject = @mailing.testing? ? "#{@mailing.subject} | TEST!!!!" : @mailing.subject
    email_with_name = "#{@user.full_name} <#{@user.email}>"
    mail to: email_with_name, subject: subject do |format|
      format.html { render layout: 'enews.html.erb' }
      format.text
    end
  end
end
