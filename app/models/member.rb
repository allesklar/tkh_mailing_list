class Member < User

  scope :validated_emails, -> { where('email_validated = ?', true) }
  scope :allowed_newsletter, -> { where('allow_newsletter = ?', true) }

end
