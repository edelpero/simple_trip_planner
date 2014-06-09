require 'spec_helper'

describe TripsHelper, :type => :helper do
  describe '#days_for_trip_to_start' do
    it 'returns remaining fays for trip to start' do
      trip = FactoryGirl.create(:trip, start_date: 2.day.from_now)
      expect(helper.days_for_trip_to_start(trip)).to eq('2 days')
    end
  end
end
