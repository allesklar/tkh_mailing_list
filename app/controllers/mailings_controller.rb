class MailingsController < ApplicationController

  before_filter :authenticate
  before_filter :authenticate_with_admin

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
    else
      recipients = Member.validated_emails.allowed_newsletter    #  @production_recipients
    end

    @actual_recipient_count = 0

    for recipient in recipients do
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
        rescue
          # TODO - create a section in the daily digest admin emais reporting errors of all kinds
        end
      else # for invalid or blank emails
        # TODO - create a section in the daily digest admin emais reporting errors of all kinds
        # AdminFeedItem.create(:body => "<a href='#{user_path(recipient)}'>#{recipient.full_name}</a> <b>did not receive</b> the email entitled '#{@mailing.title}' because of their blank or invalid email address" )
      end
    end

    # After the mailing has been sent, finish up with the following
    if @mailing.testing?
      # TODO - notify the admins somehow
      # AdminFeedItem.create(:body => "The bulk email entitled '#{@mailing.title}' <b>us sent to #{@actual_recipient_count} students</b>. The last email left at #{l Time.now, format: :just_time}. The mailing is still in test mode")
      redirect_to mailings_path, notice: 'The test mailing is being sent. Check it carefully, fix mistakes, resend. Repeat as many times as needed.'
    else
      # TODO - notify the admins somehow
     # AdminFeedItem.create(:body => "The bulk email entitled '#{@mailing.title}' <b>has been sent to #{@actual_recipient_count} students</b>. The last email left at #{l Time.now, format: :just_time}. The mailing was sent for real - that was not a test!")
     redirect_to mailins_path, notice: 'The mailing is being sent to your subscribers.'
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
