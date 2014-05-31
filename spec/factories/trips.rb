FactoryGirl.define do
  factory :trip do
    user
    destination { Faker::Venue.name }
    start_date  "2014-05-12"
    end_date    "2014-05-28"
    comment     { Faker::Lorem.paragraph(4) }
  end
end
