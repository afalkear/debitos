class GoogleUser < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation
  belongs_to :user
  has_secure_password
  before_save { |user| user.email = email.downcase }

  # TODO fill other valid email addresses
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@(metododerose\.org|derosemethod\.org|uni\-yoga\.com\.br)/
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
end
