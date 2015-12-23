class MailingsController < ApplicationController

  before_filter :authenticate
  before_action -> { require_permission_to 'write_mailings'}

  def index
    @mailings = Mailing.by_recent.paginate :page => params[:page], :per_page => 25
    switch_to_admin_layout
  end

  def show
    @mailing = Mailing.find(params[:id])
    switch_to_admin_layout
  end

  def new
    @mailing = Mailing.new
    switch_to_admin_layout
  end

  def edit
    @mailing = Mailing.find(params[:id])
    switch_to_admin_layout
  end

  def create
    @mailing = Mailing.new(mailing_params)
    if @mailing.save
      redirect_to @mailing, :notice => 'Mailing was successfully created.'
    else
      render :action => "new", :warning => 'There was a problem saving the mailing.', layout: 'admin'
    end
  end

  def update
    @mailing = Mailing.find(params[:id])
    if @mailing.update_attributes(mailing_params)
      redirect_to @mailing, :notice => 'Mailing was successfully updated.'
    else
      render :action => "edit", :warning => 'There was a problem saving the mailing.', layout: 'admin'
    end
  end

  def destroy
    @mailing = Mailing.find(params[:id])
    @mailing.destroy
    redirect_to mailings_path, notice: 'You have successfully deleted one mailing.'
  end

  def sendit
    @mailing = Mailing.find(params[:id])

    if @mailing.testing?
      recipients = User.administrators
    else # prepare the actual list
      recipients = Member.validated_emails.allowed_newsletter  # production_recipients
    end

    @actual_recipient_count = 0

    recipients.each do |recipient|
      # All recipients need an auth_token to generate unsubscribe link
      unless recipient.auth_token?
        recipient.generate_token(:auth_token)
        recipient.save
      end

      # check email validity
      if valid_email?(recipient.email)
        # Actually send the email to the subscriber
        begin
          EnewsMailer.newsletter(recipient, @mailing).deliver_now
          @actual_recipient_count += 1
        rescue Exception => e
          AdminMailer.rescued_exceptions(e, "Some exception occurred while trying to send the enewsletter.").deliver_now
        end

      else # for invalid or blank emails
        Activity.create(  doer_id: recipient.id,
                          message: "was not sent the enewsletter entitled '#{@mailing.title}' because their email address appears to be blank or invalid.",
                          for_admin_only: true   )
      end
    end

    # After the mailing has been sent, finish up with the following
    if @mailing.testing?
      redirect_to mailings_path, notice: 'The test mailing is being sent. Check it carefully, fix mistakes, resend. Repeat as many times as needed.'
    else
      # TODO - notify the admins somehow -- send email upon completion
     Activity.create( doer_id: current_user.id,
                      message: " just sent the enewsletter entitled '#{@mailing.title}' to #{Member.validated_emails.allowed_newsletter.count} subscribers."  )
     redirect_to mailings_path, notice: 'The mailing is being sent to your subscribers.'
    end
  end

  def duplicate
    @mailing = Mailing.find(params[:id])
    @mailing.duplicate!
    redirect_to mailings_path
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def mailing_params
    params.require(:mailing).permit( :title, :subject, :body_text, :body_html, :admin_note, :testing )
  end

  def valid_email?(string)
    (!string.blank? && string =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i) ? true : false
  end

end
