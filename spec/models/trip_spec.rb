require 'spec_helper'

describe Trip, :type => :model do
  describe 'validations' do
    it { should validate_presence_of(:destination) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }

    it 'validates end date to be greater than start date' do
      invalid_trip = FactoryGirl.build(:trip, start_date: '2014-05-28', end_date: '2014-05-27')
      invalid_trip.valid?
      expect(invalid_trip.errors).to include(:start_date)
    end

    it 'validates trip doesnt overlap with an existing trip' do
      FactoryGirl.create(:trip)
      invalid_trip = FactoryGirl.build(:trip)
      invalid_trip.valid?
      expect(invalid_trip.errors).to include(:base)
    end
  end
end
