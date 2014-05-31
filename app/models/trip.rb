class Trip < ActiveRecord::Base
  belongs_to :user

  validates :destination, :start_date, :end_date, presence: true
  validate  :end_date_greater_than_start_date

  scope :upcoming,  -> { where('start_date > ?', Date.current) }
  scope :current,   -> { where('start_date <= ? AND end_date >= ?', Date.current, Date.current) }
  scope :completed, -> { where('end_date < ?', Date.current) }

  private

    def end_date_greater_than_start_date
      return unless start_date && end_date

      if start_date > end_date
        errors.add(:start_date, "can't be greater than end date")
      end
    end
end
