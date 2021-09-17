FactoryBot.define do
  factory :route do
    starting_adress { "Aleje Solidarności 47, Poznań, Polska" }
    destination_adress { "Pleszewska 1, Poznań, Polska" }
    distance { 5.00 }
  end
end
