class Account < ActiveRecord::Base
  attr_accessible :name
  validates_presence_of :name
  validates_uniqueness_of :name
  after_create :create_default_responsible

  has_many :responsibles
  has_many :alumnos

  # Hook to Padma Account API
  # @param [TrueClass] cache: Specify if Cache should be used. default: true
  # @return [PadmaAccount]
  def padma(cache=true)
    api = (cache)? Rails.cache.read([self,"padma"]) : nil
    if api.nil?
      api = PadmaAccount.find(self.name)
    end
    Rails.cache.write([self,"padma"], api, :expires_in => 5.minutes) if cache && !api.nil?
    return api
  end

  # Returns usernames of this account
  # @return [Array <String>]
  def usernames
    users = PadmaUser.paginate(account_name: self.name, per_page: 100)
    users.nil? ? nil : users.map(&:username)
  end

  # Returns Students of this account
  # @return [Array <String>]
  def students(paginate_per)
    PadmaContact.paginate(select: [:first_name, :last_name], where: {local_status: :student}, account_name: self.name, per_page: paginate_per)
  end

  def synch_with_contacts
    students(1000).each do |student|
      self.alumnos.create(name: student.first_name, last_name: student.last_name, padma_id: student.id) if Alumno.where(padma_id: student.id).blank?
    end
  end

  def ready_for_summary?
    # TODO put all the necessary checks to see if this account can do a summary
    if self.responsibles.count > 0
      true
    else
      false
    end
  end

  private
    def create_default_responsible
      self.responsibles.create(name: self.name)
    end
end
