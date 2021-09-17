require "rails_helper"

RSpec.describe Route, type: :request do
  let(:starting_adress) { "Aleje Solidarności 47, Poznań, Polska" }
  let(:destination_adress) { "Pleszewska 1, Poznań, Polska" }

  before do
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
  end

  describe "GET /root" do
    it "renders a successful response" do
      get root_path
      expect(response).to be_successful
    end
  end

  describe "GET /create" do
    context "with valid parameters" do
      it "creates a new Route" do
        expect {
          get create_path, params: { starting_adress: starting_adress, destination_adress: destination_adress }
        }.to change(Route, :count).by(1)
      end

      it "redirects to root_path" do
        get create_path, params: { starting_adress: starting_adress, destination_adress: destination_adress }
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Restaurant" do
        expect {
          get create_path, params: { starting_adress: starting_adress, destination_adress: nil }
        }.to change(Route, :count).by(0)
      end

      it "redirects to root_path with error" do
        get create_path, params: { starting_adress: starting_adress, destination_adress: nil }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq "Destination adress can't be blank"
      end
    end
  end
end
