# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'ffaker'

beginning_date = 3.weeks.ago.to_date

user = User.create(email: 'admin@simpletripplanner.com', password: 'thisisatest',
  password_confirmation: 'thisisatest')

40.times {
  end_date = beginning_date + 3.days

  trip = Trip.new(
    destination: Faker::Address.country,
    start_date:  beginning_date,
    end_date:    end_date,
    user:        user)
  trip.save(validate: false)

  beginning_date = end_date + 1.day
}
