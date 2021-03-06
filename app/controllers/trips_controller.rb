class TripsController < ApplicationController
  before_action :find_trip, only: [:show, :edit, :update, :destroy]

  has_scope :upcoming, type: :boolean
  has_scope :past,     type: :boolean
  has_scope :between, using: [:started_at, :ended_at], type: :hash
  has_scope :destination

  def index
    @trips = apply_scopes(current_user.trips.order(:start_date)).page(params[:page])
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

  def next_month
    next_month_beginning = 1.month.from_now.beginning_of_month.to_date
    next_month_ending    = 1.month.from_now.end_of_month.to_date

    @trips = current_user.trips.overlaping(next_month_beginning, next_month_ending).
      order(:start_date).page(params[:page])
  end

  protected

    def find_trip
      @trip = current_user.trips.find(params[:id])
    end

    def trip_params
      params.require(:trip).permit(:destination, :start_date, :end_date, :comment)
    end
end
