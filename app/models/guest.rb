class Guest < ActiveRecord::Base
  belongs_to :company
  has_many :request_attendances, as: :attendee

  attr_encrypted :first_name, random_iv: true
  attr_encrypted :last_name, random_iv: true
  attr_encrypted :email, random_iv: true

  validates :encrypted_first_name, symmetric_encryption: true
  validates :encrypted_last_name, symmetric_encryption: true

  store_accessor :data

end
