class Member < User

  scope :validated_emails, -> { where('email_validated = ?', true) }
  scope :allowed_newsletter, -> { where('allow_newsletter = ?', true) }

  def unsubscribe_from_newsletter!
    allow_newsletter = false
    save
  end

end
