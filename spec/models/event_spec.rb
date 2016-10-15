require 'rails_helper'

RSpec.describe Event, :type => :model do
  subject(:event) { Fabricate.build(:event) }

  context "is invalid" do

    specify "without a name" do
      event.name = nil
      expect(event).to_not be_valid
    end

    specify 'without a company' do
      event.company = nil
      expect(event).to_not be_valid
    end

    specify 'with an invalid status' do
      event.status = 'FishSauce'
      expect(event).to_not be_valid
    end

    specify 'without a status' do
      event.status = nil
      expect(event).to_not be_valid
    end



  end
end
