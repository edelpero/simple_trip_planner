require 'spec_helper'

describe TripsController, :type => :controller do

  before do
    @user = FactoryGirl.create(:user)
    sign_in :user, @user
    sign_in @user
    allow(controller).to receive(:current_user).and_return(@user)
  end

  describe 'before_actions' do
    before do
      @trips = double(Trip)
      allow(@user).to receive(:trips).and_return(@trips)
    end

    describe 'find_trip' do
      context 'when trip found' do
        before do
          allow(@trips).to receive(:find).and_return(:trip)
        end

        it 'assigns trip' do
          get :show, id: '1'
          expect(assigns(:trip)).to eq(:trip)
        end
      end

      context 'when trip not found' do
        before do
          allow(@trips).to receive(:find) { raise ActiveRecord::RecordNotFound }
        end

        it 'reponds with status 404' do
          get :show, id: 1
          expect(response.status).to eq(404)
        end
      end
    end
  end

  describe 'GET#index' do
    before do
      @trips = double(Trip)
      allow(@user).to receive(:trips).and_return(@trips)
      allow(@trips).to receive(:order).and_return(@trips)
      allow(@trips).to receive(:page).and_return(@trips)
    end

    it "retrivies all user's trip" do
      get :index
      expect(assigns(:trips)).to eq(@trips)
    end

    it 'it retrivies all upcoming trips from user' do
      expect(@trips).to receive(:upcoming).and_return(@trips)
      get :index, upcoming: true
    end

    it 'it retrivies all past trips from user' do
      expect(@trips).to receive(:past).and_return(@trips)
      get :index, past: true
    end

    it 'renders trips/index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET#new' do
    before do
      @trips = double(Trip)
      allow(@user).to receive(:trips).and_return(@trips)
    end

    it 'creates an instace of a user trip' do
      expect(@trips).to receive(:new)
      get :new
    end
  end

  describe 'POST#create' do
    it 'creates an instace of a user trip with trip params' do
      trip_params = { destination: 'Brasil',
        start_date: 1.day.from_now.to_date.to_s,
        end_date:   2.days.from_now.to_date.to_s }
      post :create, trip: trip_params
      expect(assigns(:trip)).to be_kind_of(Trip)
    end

    context 'with valid attributes' do
      it 'redirects to trip_path' do
        trip_params = { destination: 'Brasil',
          start_date: 1.day.from_now.to_date.to_s,
          end_date:   2.days.from_now.to_date.to_s }
        post :create, trip: trip_params
        expect(response).to redirect_to(trip_path(assigns(:trip)))
      end
    end

    context 'with invalid attributes' do
      it 'renders new template' do
        trip_params = { destination: 'Brasil',
          start_date: 2.day.from_now.to_date.to_s,
          end_date:   1.days.from_now.to_date.to_s }
        post :create, trip: trip_params
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT#update' do
    before do
      @trip = FactoryGirl.create(:trip, user: @user)
      allow(@user).to receive(:trips).and_return(@trip)
      allow(@trip).to receive(:find).and_return(@trip)
    end

    context 'with valid attributes' do
      it 'redirects to trip_path' do
        trip_params = { destination: 'Brasil',
          start_date: 1.day.from_now.to_date.to_s,
          end_date:   2.days.from_now.to_date.to_s }
        put :update, id: @trip.id, trip: trip_params
        expect(response).to redirect_to(trip_path(@trip))
      end
    end

    context 'with invalid attributes' do
      it 'renders edit template' do
        trip_params = { destination: 'Brasil',
          start_date: 2.day.from_now.to_date.to_s,
          end_date:   1.days.from_now.to_date.to_s }
        put :update, id: @trip.id, trip: trip_params

        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE#destroy' do
    before do
      @trip = FactoryGirl.create(:trip, user: @user)
      allow(@user).to receive(:trips).and_return(@trip)
      allow(@trip).to receive(:find).and_return(@trip)
    end

    context 'when destroy success' do
      it 'redirects to trip index' do
        delete :destroy, id: @trip.id
        expect(response).to redirect_to(trips_path)
      end
    end

    context 'when destroy fails' do
      before do
        allow(@trip).to receive(:destroy).and_return(false)
      end

      it 'redirects to trip show' do
        delete :destroy, id: @trip.id
        expect(response).to redirect_to(trip_path(@trip))
      end
    end
  end

  describe 'GET#next_month' do
    before do
      @trips = double(Trip)
      allow(@user).to receive(:trips).and_return(@trips)
      allow(@trips).to receive(:overlaping).and_return(@trips)
      allow(@trips).to receive(:order).and_return(@trips)
      allow(@trips).to receive(:page).and_return(@trips)
    end

    it "retrivies all user's trip" do
      get :next_month
      expect(assigns(:trips)).to eq(@trips)
    end

    it 'renders trips/index template' do
      get :next_month
      expect(response).to render_template(:next_month)
    end
  end

end
