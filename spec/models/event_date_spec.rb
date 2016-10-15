require 'rails_helper'

RSpec.describe EventDate, :type => :model do
  subject (:event_date) { Fabricate.build(:event_date) }

  context "is invalid" do
    specify "when the end date is before the start date" do
      event_date.start = Time.now
      event_date.finish = 1.day.ago
      is_expected.to_not be_valid
    end

    specify 'when it is not attached to an event' do
      event_date.event = nil
      is_expected.to_not be_valid
    end

  end


  context "is valid" do
    specify 'when created with the correct data' do
      is_expected.to be_valid
    end
  end

  # context 'handles attached files correctly' do
  #   specify "when it doesn't have one attached"  do
  #     event_date.event.tile = Rails.root.join('spec/test_files/blank.jpg'), 'image/jpeg'
  #
  #     expect(event_date.tile).to eq('foobar')
  #   end
  # end
end
