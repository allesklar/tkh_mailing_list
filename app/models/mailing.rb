class Mailing < ActiveRecord::Base

  validates_presence_of :title, :subject, :body_text, :body_html

  translates :title, :subject, :body_text, :body_html

  scope :by_recent, -> { order('created_at desc') }

  def duplicate!
    old_mailing = self
    new_mailing = old_mailing.dup
    new_mailing.title = "Copy of #{old_mailing.title}"
    new_mailing.save
    # not very pretty but it works fine. Had to do this manually otherwise the mailing
    # fields would not be duplicated over to the new course record in their respective language.
    translated_attributes = [ 'title', 'subject', 'body_text', 'body_html' ]
    I18n.available_locales.each do |loc|
      translated_attributes.each do |attr|
        new_mailing.write_attribute( attr.to_sym, self.read_attribute( attr.to_sym, locale: loc ), locale: loc)
      end
    end
    new_mailing.title = "Copy of #{new_mailing.title}"
    new_mailing.save
  end

end
