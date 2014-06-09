module TripsHelper
  def days_for_trip_to_start(trip)
    remaining_days = (trip.start_date - Date.current).to_i

    if remaining_days > 0
      pluralize(remaining_days, 'day')
    end
  end
end
