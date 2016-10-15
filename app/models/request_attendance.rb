class RequestAttendance < ActiveRecord::Base
  belongs_to :released_inventory_request
  belongs_to :attendee, polymorphic: true

  store_accessor :data, :invite_sent, :rsvp_returned, :email_opened, :survey_response
end
