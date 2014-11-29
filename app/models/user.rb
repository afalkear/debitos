# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me,
  attr_accessible :email, :name, :card_companies_attributes, :username, :current_account_id
  #:password, :password_confirmation, :card_companies_attributes, :username
  has_many :alumnos
  has_many :google_users, :dependent => :destroy
  has_many :card_companies, :dependent => :destroy
  # has_secure_password

  devise :cas_authenticatable
  include Accounts::IsAUser

  belongs_to :current_account, :class_name => "Account"

  accepts_nested_attributes_for :card_companies, :reject_if => lambda { |a| a[:establishment].blank? }, :allow_destroy => true

  before_save { |user| user.email = email.downcase }
  # before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }

  validates_associated :card_companies
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  #   uniqueness: { case_sensitive: false }
    
  # validates_presence_of :password_confirmation, length: { minimum: 6 }, :if => :password_present?
  # validates_confirmation_of :password, :if => :password_present?

  validates_uniqueness_of :username
  validates_presence_of :username

  def accounts
    self.padma.enabled_accounts
  end

  # Accounts::IsAUser needs class to respond_to account_name
  def account_name
    self.current_account.try :name
  end

  # Accounts::IsAUser needs class to respond_to account_name=
  def account_name=(name)
    self.current_account = Account.find_by_name(name)
  end

  # Accounts::IsAUser needs class to respond_to account_name_changed?
  def account_name_changed?
    self.current_account_id_changed?
  end

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

    def password_present?
      !password.nil?
    end
end
