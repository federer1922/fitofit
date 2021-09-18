FactoryBot.define do
  factory :route do
    starting_adress { Faker::Address.full_address }
    destination_adress { Faker::Address.full_address }
    distance { 5 }
  end
end
