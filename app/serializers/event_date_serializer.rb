class EventDateSerializer < ActiveModel::Serializer
  attributes :id, :event_name, :event_id, :ticketing_event_code, :ticketing_event_code_box, :ticketing_event_code_cl, :tile, :agenda, :menu, :event_tile, :event_agenda, :event_menu, :event_status

  def attributes
    hash = super
    hash["start"] = object.event_period.begin.to_i
    hash["finish"] = object.event_period.end.to_i
    hash
  end

end
