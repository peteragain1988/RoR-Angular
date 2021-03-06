class Employee < ActiveRecord::Base

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  belongs_to :company
  belongs_to :department
  has_one :profile, class_name: 'Profile'
  belongs_to :approval_path

  accepts_nested_attributes_for :profile
  accepts_nested_attributes_for :approval_path

  validates :email, presence: { message: 'User Email cannot be blank' },
            uniqueness:  { case_sensitive: false },
            format: { with: EMAIL_REGEX }

  validates :company_id, presence: true
  validates :permissions, presence: true

  has_many :request_attendances, as: :attendee

  has_many :released_inventory_requests, foreign_key: :requester_id

  store_accessor :permissions, :can_login?, :login_disabled?, :venue_admin?, :super_admin?, :client_admin?, :developer

  store_accessor :config, :state, :position, :cost_center, :bi_access


  # validation for password should be false, because when employee is created password is not set
  has_secure_password validations: false

  delegate :can?, :cannot?, to: :ability


  delegate :first_name, to: :profile, allow_nil: true
  delegate :last_name, to: :profile, allow_nil: true
  delegate :full_name, to: :profile, allow_nil: true

  delegate :name, to: :company, prefix: true, allow_nil: true
  delegate :name, to: :department, prefix: true, allow_nil: true



  class << self
    def verifier_for(purpose)
      @verifiers ||= {}
      @verifiers.fetch(purpose) do |p|
        @verifiers[p] = Rails.application.message_verifier("#{self.name}-#{p.to_s}")
      end
    end

    def for_password_token(token)
      employee_id, timestamp = verifier_for('reset-password').verify(token)
      find(employee_id)
    end
    
  end
    
  def reset_password_token
    verifier = self.class.verifier_for('reset-password') # Unique for each type of messages
    verifier.generate([id, Time.now])
  end

  def reset_password!(params)
    # This raises an exception if the message is modified
    employee_id, timestamp = self.class.verifier_for('reset-password').verify(params[:token])

    if timestamp > 1.day.ago
      self.password = params[:password]
      self.password_confirmation = params[:password_confirmation]
      save!
    else
      # Token expired
      # ...
    end
  end

  def verify_totp(otp)
    return false unless self.otp_secret
    totp = ROTP::TOTP.new(self.otp_secret)
    totp.verify(otp)
  end

  def update_totp_secret
    secret = ROTP::Base32.random_base32
    update_attribute :otp_secret, secret
    secret
  end

  def uri_for_totp_secret
    totp = ROTP::TOTP.new(otp_secret)
    totp.provisioning_uri(email)
  end

  def ability
    @ability ||= Ability.new(self)
  end
end
