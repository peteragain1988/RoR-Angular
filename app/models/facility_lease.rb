class FacilityLease < ActiveRecord::Base
  self.table_name = :companies_facilities
  belongs_to :facility
  belongs_to :company
  belongs_to :owner, foreign_key: :owner_id, class_name: 'Company'

  before_save :update_timerange

  # define accessors for our virtual attributes
  attr_accessor :start, :finish

  scope :active, ->() { where('now() <@ companies_facilities.lease_period AND companies_facilities.is_enabled = true') }

  validates_numericality_of :finish, greater_than: :start

  delegate :name, to: :company, prefix: true
  delegate :name, to: :facility, prefix: true


  protected
  def update_timerange
    self.lease_period = Time.at(self.start).utc...Time.at(self.finish).utc if start && finish
  end

end
