class SignupsController < ApplicationController

  # FIXME
  # main method should be named 'signup_for_newsletter' to be correct
  # big refactoring will be needed when implementing multiple newsletter feature
  def email_verification
    unless params[:user][:email].blank?
      @user = User.find_or_initialize_by(email: params[:user][:email])

      if @user.email_validated? == false

        set_email_validation_token
        @user.allow_newsletter = true
        @user.allow_daily_digests = true
        @user.save ? @validation_ready=true : @validation_ready=false
        SignupMailer.verification_email(@user).deliver
        Activity.create doer_id: @user.id, message: "signed up for the newsletter. Email: #{@user.email}"
        # render the email_verification view

      else # the email address has already been validated

        if @user.allow_newsletter?
          redirect_to root_path, notice: "You are already subscribed to the newsletter. Nothing to do but wait for the next issue."
        else # the user just subscribed for the first time.
          @user.allow_newsletter = true
          @user.allow_daily_digests = true
          @user.save
          Activity.create doer_id: @user.id, message: "signed up for the newsletter. Email: #{@user.email}"
          redirect_to root_path, notice: "Thank you for subscribing to the newsletter."
        end

      end

    else  # the email field is blank
       redirect_to :back, alert: 'Your email cannot be blank. Please enter your email address and try again'
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
