class ContactsController < ApplicationController

  before_action :authenticate,                             except: [ :create ]
  before_action -> { require_permission_to 'write_contacts'}, except: [ :create ]

  def index
    @contacts = Contact.by_recent.paginate(:page => params[:page], :per_page => 35)
    switch_to_admin_layout
  end

  def show
    @contact = Contact.find(params[:id])
    switch_to_admin_layout
  end

  def create
    @contact = Contact.new(contact_params)
    # the website form field is invisible to human visitors and works as
    # a honeypot to spam robots
    honeypotted = @contact.website.present?
    saved = @contact.save unless honeypotted
    # disabling this and replacing it with a daily digest
    # this is to mitigate the pain associated with contact spams
    # sent_email = send_message_to_admin(@contact)
    # if saved && sent_email == 'success'
    #   redirect_to root_path, notice: t("contacts.create.notice")
    # elsif saved && sent_email == 'exception'
    #   flash[:error] = t("contacts.create.warning")
    #   redirect_to :back
    # elsif saved && sent_email == 'invalid'
    #   flash[:error] =  "#{t("contacts.create.warning")} #{t('contacts.create.invalid_email')}"
    #   redirect_to :back
    # else
    #   flash[:error] = t('contacts.create.did_not_reach')
    #   redirect_to :back
    # end

    if saved || honeypotted
      redirect_to root_path, notice: t("contacts.create.notice")
    else
      redirect_to :back, alert: t('contacts.create.did_not_reach')
    end
  end

  def valid_email?(string)
    (!string.blank? && string =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i) ? true : false
  end
  # helper_method :valid_email?

  private

  #  disabled to be replaced by daily digest to admins
  # def send_message_to_admin(contact)
  #   # check email validity
  #   if valid_email?(contact.sender_email)
  #     # Actually send the email to the student
  #     begin
  #       ContactMailer.message_from_contact_form(contact).deliver
  #       return 'success'
  #     rescue Exception => e
  #       AdminMailer.rescued_exceptions(e, "Some exception occurred while trying to send to site admin a message from contact form").deliver
  #       @exception = e
  #       return 'exception'
  #     end
  #   else # for invalid or blank emails
  #     return 'invalid'
  #   end
  # end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_params
    params.require(:contact).permit(:sender_name, :sender_email, :body, :website)
  end


end
