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

    describe 'validates trip doesnt overlap with an existing trip from same user' do
      before do
        @trip = FactoryGirl.create(:trip)
        @user = @trip.user
      end

      context 'with same user' do
        it 'does not saves trip if dates overlaps' do
          invalid_trip = FactoryGirl.build(:trip, user: @user)
          invalid_trip.valid?
          expect(invalid_trip.errors).to include(:base)
        end

        it 'saves trip if dates does not overlaps' do
          valid_trip = FactoryGirl.build(:trip, user: @user, start_date: 2.weeks.from_now, end_date: 3.weeks.from_now)
          expect(valid_trip.save).to eq(true)
        end
      end

      context 'with another user' do
        it 'saves the trip if dates overlaps with another users trip' do
          valid_trip = FactoryGirl.build(:trip)
          expect(valid_trip.save).to eq(true)
        end
      end
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

    describe '.past' do
      it 'returns past trips' do
        trip = FactoryGirl.build(:trip, start_date: 1.month.ago, end_date: 2.weeks.ago)
        trip.save(validate: false)
        results = Trip.past
        expect(results).to include(trip)
      end
    end

    describe '.for_user' do
      before do
        @first_trip   = FactoryGirl.create(:trip)
        @user         = @first_trip.user
        @second_trip  = FactoryGirl.create(:trip, user: @user, start_date: 2.weeks.from_now, end_date: 3.weeks.from_now)
        @third_trip   = FactoryGirl.create(:trip)
        @another_user = @third_trip.user
      end

      it 'returns trips from specific user' do
        results = Trip.for_user(@user)
        expect(results).to include(@first_trip, @second_trip)
      end

      it 'does not returns trip from another user' do
        results = Trip.for_user(@user)
        expect(results).not_to include(@third_trip)
      end
    end
  end
end
