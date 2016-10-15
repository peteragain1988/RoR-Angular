class EventDate < ActiveRecord::Base
  include EventUploads

  belongs_to :event
  has_many :facilities, through: :inventories
  has_many :inventories
  has_many :tickets
  has_many :confirmed_inventory_options, through: :inventories

  scope :not_finished, -> { where( 'upper(event_dates.event_period) > now()') }

  before_validation :create_time_range

  attr_writer :start, :finish
  define_method :start, -> { event_period  && event_period.begin || 0 }
  define_method :finish, -> { event_period && event_period.end || 0 }

  validates_datetime :start, before: :finish, before_message: 'time must be before the end time'
  validates_datetime :finish, after: :start, after_message: 'time must be after the start time'

  validates :event, presence: true

  delegate :name, to: :event, prefix: true
  delegate :promoter, to: :event, prefix: true

  store_accessor :data, :ticketing_event_code, :ticketing_event_code_box, :ticketing_event_code_cl

  define_method :event_tile, -> { tile.presence || event.tile }
  define_method :event_agenda, -> { agenda.presence || event.agenda }
  define_method :event_menu, -> { menu.presence || event.menu }
  define_method :event_status, -> { status.presence || event.status }

  def create_time_range
    write_attribute(:event_period, Time.at(@start).utc...Time.at(@finish).utc)
  end

  # TODO make this more railsy
  def self.data_for_release(id)
    sql = <<-SQL
      SELECT facilities.name as facility_name, companies.name AS company_name, facilities.capacity AS total, facilities.capacity AS remaining,
      companies_facilities.company_id AS client_id, companies_facilities.facility_id, facilities.company_id, (SELECT '#{id}') AS event_date_id
      FROM companies_facilities
      JOIN facilities ON facilities.id = companies_facilities.facility_id
      JOIN companies ON companies.id = companies_facilities.company_id
      WHERE NOT EXISTS (SELECT * FROM inventory WHERE inventory.event_date_id = '#{id}' AND inventory.facility_id = companies_facilities.facility_id)
      AND (SELECT event_period FROM event_dates WHERE event_dates.id = '#{id}') <@ companies_facilities.lease_period
    SQL

    find_by_sql(sql)
  end


end
