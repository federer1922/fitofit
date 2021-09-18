require "rails_helper"

RSpec.describe "calculate distance" do
  Geocoder.configure(:lookup => :test)
  it "calculates correct distance" do

    starting_adress = "Aleje Solidarności 47, Poznań, Polska"
    Geocoder::Lookup::Test.add_stub(
      starting_adress, [
        {
          "coordinates" => [50.4378721, 18.9189229],
          "address"=>
          {"shop"=>"Carrefour",
           "house_number"=>"47",
           "road"=>"Aleje Solidarności",
           "neighbourhood"=>"Trójpole",
           "suburb"=>"Winiary",
           "city"=>"Poznań",
           "state"=>"Greater Poland Voivodeship",
           "postcode"=>"61-696",
           "country"=>"Poland",
           "country_code"=>"pl"}
        }
      ]
    )

    destination_adress = "Pleszewska 1, Poznań, Polska"
    Geocoder::Lookup::Test.add_stub(
     destination_adress, [
        {
          "coordinates" => [50.3953131, 18.9564764], 
          "address"=>
          {"amenity"=>"Poczta Polska",
          "house_number"=>"1",
          "road"=>"Pleszewska",
          "neighbourhood"=>"Trójpole",
          "suburb"=>"Winiary",
          "city"=>"Poznań",
          "state"=>"Greater Poland Voivodeship",
          "postcode"=>"61-696",
          "country"=>"Poland",
          "country_code"=>"pl"}
        }
      ]
    )

    distance = CalculateDistance.call(starting_adress, destination_adress)

    expect(distance).to eq 5.429081525792754
  end
end