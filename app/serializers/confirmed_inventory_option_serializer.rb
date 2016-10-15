class ConfirmedInventoryOptionSerializer < ActiveModel::Serializer
  attributes :id, :selection, :guests, :created_at, :is_attending,
             :data, :facility_name , :facility_number, :event_date,
             :company_name, :company_ticket_type, :event_name

  has_one :company

  def event_date
    object.event_date.event_period.begin.to_i
  end

  def company_name
    object.company.friendly_name
  end

  def company_ticket_type
    object.company.ticket_type
  end

  def event_name
    object.event.name
  end

  def facility_name
    object.facility.name
  end

  def facility_number
    object.facility.name.scan(/\d/).join('').to_i
  end

  def manager_name
    object.company.manager.name
  end
end
