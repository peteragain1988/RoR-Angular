class Event < ActiveRecord::Base
  include EventUploads
  belongs_to :company

  has_many :inventories, through: :dates
  has_many :tickets, through: :inventories
  has_many :confirmed_inventory_options, through: :inventories
  has_many :dates, class_name: 'EventDate'


  scope :currently_open, -> { where( "events.status IN (?)", ['Open', 'Closing Soon']) }
  scope :reportable, -> { where( "events.status IN (?)", ['Open', 'Closing Soon', 'Closed']) }
  scope :closed, -> { where( status: 'Closed') }
  scope :not_closed, -> { where.not( status: 'Closed') }


  validates_presence_of :name
  validates :company, presence: true
  validates :status, inclusion: ['Open', 'Closed', 'Closing Soon', 'Coming Soon']


  store_accessor :data, :promoter
end
