FactoryGirl.define do
  factory :trip do
    user
    destination { Faker::Venue.name }
    start_date  { Date.current }
    end_date    { 12.days.from_now }
    comment     { Faker::Lorem.paragraph(4) }
  end
end
