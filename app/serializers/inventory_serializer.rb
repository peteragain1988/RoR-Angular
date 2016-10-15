class InventorySerializer < ActiveModel::Serializer
  attributes :id, :status,
             :facility_name, :event_name, :event_date_id,
             :client_name, :venue_name,
             :event_start, :event_type,
             :is_confirmed, :inventory_options,
             :confirmation_id, :event_status, :released_ticket_count, :event_agenda, :event_menu,
             :confirmation_data

  def inventory_options
    object.options
  end

  def released_ticket_count
    object.released_tickets.size
  end

  def confirmation_data
    object.confirmed_inventory_option.data if object.confirmed_inventory_option
  end

  def event_agenda
    object.event_date.event_agenda
  end

  def event_menu
    object.event_date.event_menu
  end

  def event_date_id
    object.event_date.id
  end

  def confirmation_id
    object.confirmed_inventory_option.id unless object.confirmed_inventory_option.nil?
  end

  def is_confirmed
    !object.confirmed_inventory_option.nil?
  end

  def event_status
    object.event_date.event_status
  end

  def facility_name
    object.facility.name
  end

  def event_type
    object.event_date.event.event_type
  end

  def event_name
    object.event_date.event.name
  end

  def client_name
    object.client.friendly_name
  end

  def venue_name
    object.facility.company.name
  end

  def event_start
    object.event_date.event_period.begin.to_i
  end
end