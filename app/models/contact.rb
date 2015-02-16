class Contact < ActiveRecord::Base

  validates_presence_of :sender_name
  validates_presence_of :sender_email
  # validates :sender_email, :presence => true, :format => { :with => /\A([\A@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :on => :create }
  validates_presence_of :body

  scope :yesterdays, lambda { where('created_at >= ? AND created_at <= ?', 1.day.ago.beginning_of_day, 1.day.ago.end_of_day ) }
  scope :chronologically, -> { order('created_at') }
  scope :by_recent, -> { order('created_at desc') }

end
