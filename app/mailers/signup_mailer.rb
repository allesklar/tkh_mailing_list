class SignupMailer < ActionMailer::Base
  default from: "#{Setting.first.try(:site_name)} <#{Setting.first.contact_email}>"

  def verification_email(user)
    @user = user
    mail to: @user.email, subject: "Email address validation"
  end
end
