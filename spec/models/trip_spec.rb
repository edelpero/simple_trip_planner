require 'spec_helper'

describe Trip, :type => :model do
  describe 'validations' do
    it { should validate_presence_of(:destination) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }

    it 'validates end date to be greater than start date' do
      invalid_trip = FactoryGirl.build(:trip, start_date: 2.days.from_now, end_date: 1.day.from_now)
      invalid_trip.valid?
      expect(invalid_trip.errors).to include(:start_date)
    end

    it 'validates trip doesnt overlap with an existing trip' do
      FactoryGirl.create(:trip)
      invalid_trip = FactoryGirl.build(:trip)
      invalid_trip.valid?
      expect(invalid_trip.errors).to include(:base)
    end

    it 'validates start_date is not a date in the past' do
      invalid_trip = FactoryGirl.build(:trip, start_date: 1.day.ago)
      invalid_trip.valid?
      expect(invalid_trip.errors).to include(:start_date)
    end
  end

  describe 'scopes' do
    describe '.upcoming' do
      it 'returns trips which have not started yet' do
        trip = FactoryGirl.create(:trip, start_date: 1.day.from_now)
        results = Trip.upcoming
        expect(results).to include(trip)
      end
    end

    describe '.current' do
      it 'returns the current trip' do
        trip = FactoryGirl.create(:trip)
        results = Trip.current
        expect(results).to include(trip)
      end
    end
  end
end
