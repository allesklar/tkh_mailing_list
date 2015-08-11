class Member < User

  scope :validated_emails, -> { where('email_validated = ?', true) }
  scope :allowed_newsletter, -> { where('allow_newsletter = ?', true) }

  def unsubscribe_from_newsletter!
    # for some reason the self bit is necessary. I thought it would not be.
    self.allow_newsletter = false
    self.save
  end

end
