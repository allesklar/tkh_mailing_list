class SignupsController < ApplicationController

  def email_verification
    unless params[:user][:email].blank?
      @user = User.find_or_initialize_by(email: params[:user][:email])
      set_email_validation_token
      @user.allow_newsletter = true
      @user.allow_daily_digests = true
      @user.save ? @validation_ready=true : @validation_ready=false
      SignupMailer.verification_email(@user).deliver
      Activity.create doer_id: @user.id, message: "signed up for the newsletter. Email: #{@user.email}"
    else
     redirect_to root_path, alert: 'Your email cannot be blank. Please enter your email address and try again'
    end
  end

  def email_confirmation
    @user = User.where(email_validation_token: params[:token]).first
    if @user && @user.email_validation_token_sent_at >= Time.zone.now - 1.hour
      @user.email_validated = true
      @user.save
      @email_confirmed = true
    elsif @user && @user.email_validation_token_sent_at <= Time.zone.now - 1.hour
      redirect_to root_url, alert: "Your verification token was created over an hour ago. Please restart the process."
    else
      @email_confirmed = false
    end
  end

  private

  def set_email_validation_token
    @user.generate_token(:email_validation_token)
    @user.email_validation_token_sent_at = Time.zone.now
    @user.save
  end

end
