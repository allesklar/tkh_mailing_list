class Administration < ActiveRecord::Base

  def self.send_daily_digest
    digest_is_needed = false
    @yesterdays_contact_messages = Contact.yesterdays.chronologically
    digest_is_needed = true if @yesterdays_contact_messages.count > 0
    if digest_is_needed
      User.administrators.each do |administrator|
        send_message_to_admin(administrator)
      end
    end
  end

  private

  def self.send_message_to_admin(recipient)
    # Actually send the email to the administrator
    begin
      AdministrationMailer.daily_digest( recipient, @yesterdays_contact_messages ).deliver_now
      return 'success'
    rescue Exception => e
      AdminMailer.rescued_exceptions(e, "Some exception occurred while trying to send to site admin a message from contact form").deliver
      @exception = e
      return 'exception'
    end
  end

end