class TripsController < ApplicationController
  before_action :find_trip, only: [:show, :edit, :update, :destroy]

  has_scope :upcoming, type: :boolean
  has_scope :past,     type: :boolean
  has_scope :between, using: [:started_at, :ended_at], type: :hash
  has_scope :destination

  def index
    @trips = apply_scopes(current_user.trips)
  end

  def show
  end

  def new
    @trip = current_user.trips.new
  end

  def create
    @trip = current_user.trips.new(trip_params)

    if @trip.save
      redirect_to @trip, notice: 'Trip created succeesfully.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @trip.update(trip_params)
      redirect_to @trip, notice: 'Trip updated succeesfully.'
    else
      render :edit
    end
  end

  def destroy
    if @trip.destroy
      redirect_to trips_path, notice: 'Trip deleted succeesfully.'
    else
      redirect_to @trip, alert: 'Something went wrong, please try again.'
    end
  end

  protected

    def find_trip
      @trip = current_user.trips.find(params[:id])
    end

    def trip_params
      params.require(:trip).permit(:destination, :start_date, :end_date, :comment)
    end
end
