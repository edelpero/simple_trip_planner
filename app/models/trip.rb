class Trip < ActiveRecord::Base
  belongs_to :user

  validates :destination, :start_date, :end_date, presence: true
  validate  :end_date_greater_than_start_date
  validate  :trip_doesnt_overlap_scoped_to_user
  validate  :start_date_is_not_a_past_date

  scope :upcoming,  -> { where('start_date > ?', Date.current) }
  scope :current,   -> { where('start_date <= ? AND end_date >= ?', Date.current, Date.current) }
  scope :past,      -> { where('end_date < ?', Date.current) }
  scope :overlaping, -> (start_date, end_date) { where('(start_date BETWEEN ? AND ?) OR (end_date BETWEEN ? AND ?)', start_date, end_date, start_date, end_date) }
  scope :for_user,  -> (user) { where(user: user) }

  private

    def end_date_greater_than_start_date
      return unless start_date && end_date

      if start_date > end_date
        errors.add(:start_date, "can't be greater than end date")
      end
    end

    def trip_doesnt_overlap_scoped_to_user
      return unless start_date && end_date

      start_range = start_date + 1.day
      end_range   = end_date - 1.day

      overlaping_trips = Trip.for_user(user).overlaping(start_date, end_date)
      if overlaping_trips.any?
        errors.add(:base, "This trip overlaps with an existing one")
      end
    end

    def start_date_is_not_a_past_date
      return unless start_date

      if Date.current > start_date
        errors.add(:start_date, "can't be a date in the past")
      end
    end
end
