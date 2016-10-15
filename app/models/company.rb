class Company < ActiveRecord::Base
  # TODO Split this class, STI style. Currently its very messy and unclear as to what is happening

  store_accessor :address, :address1, :address2, :postcode, :suburb, :state, :city
  store_accessor :contact, :phone, :fax
  store_accessor :notifications, :notify_sms, :notify_email
  store_accessor :modules, :guest_module
  store_accessor :config, :ticket_type, :payment_terms, :order_block

  delegate :email, to: :manager, prefix: true
    
  has_many :menus
  has_many :events
  has_many :employees
  has_many :facilities
  has_many :inventories

  has_many :client_inventories, class_name: 'Inventory', foreign_key: :client_id

  has_many :inventory_tickets, class_name: 'Ticket', foreign_key: :client_id
  has_many :confirmed_inventory_options, foreign_key: :client_id
  has_many :event_dates, through: :events

  # has_many :client_companies
  has_many :facility_leases

  # Facilities we own and are leasing out
  has_many :leased_out_facilities, table_name: :companies_facilities, foreign_key: :owner_id, class_name: 'FacilityLease'


  # has_many :clients, through: :client_companies

  has_and_belongs_to_many :clients, class_name: 'Company',
                          join_table: :clients_companies,
                          association_foreign_key: :client_id

  has_and_belongs_to_many :venues, class_name: 'Company',
                          join_table: :clients_companies,
                          association_foreign_key: :company_id,
                          foreign_key: :client_id

  belongs_to :manager, class_name: 'Employee'

  def managers
    employees.where("employees.permissions ->> 'client_admin?' = 'true'")
  end

  validates_presence_of :name, :friendly_name
  # validates_format_of :name, :friendly_name, with: /\A[[:alpha:]\s'"\-_&@!?()\[\]-]*\Z/u

  before_validation :set_friendly_name_from_name


  def self.search_with_uuids(uuids)
    self.find(uuids)
  end

  protected
  def set_friendly_name_from_name
      self.friendly_name = self[:name] if self[:name]
    end

end
