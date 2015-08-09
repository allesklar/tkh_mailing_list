class Administration < ActiveRecord::Base

  # this method is triggered by a rake task in this gem
  def self.send_daily_digest
    digest_is_needed = false
    @yesterdays_contact_messages = Contact.yesterdays.chronologically
    @pending_comments = Comment.pending.by_created
    @yesterdays_activities = Activity.yesterdays.chronologically
    digest_is_needed = true if @yesterdays_contact_messages.count > 0 || @pending_comments.count > 0 || @yesterdays_activities.count > 0
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
      AdministrationMailer.daily_digest( recipient, @yesterdays_contact_messages, @pending_comments, @yesterdays_activities ).deliver_now
      return 'success'
    rescue Exception => e
      AdminMailer.rescued_exceptions(e, "Some exception occurred while trying to send to site admin the daily digest.").deliver
      @exception = e
      return 'exception'
    end
  end

end
