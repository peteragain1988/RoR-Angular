class Facility < ActiveRecord::Base
  has_many :inventories
  has_many :leasees, through: :facility_leases, class_name: 'Company', source: :company
  has_many :facility_leases
  belongs_to :company

  has_one :current_active_lease, -> { where('now() <@ companies_facilities.lease_period AND companies_facilities.is_enabled = true') }, class_name: 'FacilityLease'

  accepts_nested_attributes_for :facility_leases


  validates_presence_of :name, :company_id, :capacity, :facility_type
  validates_numericality_of :capacity, minimum: 1


  before_save :capitalize_name

  def capitalize_name
    self.name.capitalize! if self.name && !self.name.blank?
  end
end
