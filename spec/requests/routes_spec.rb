require "rails_helper"

RSpec.describe Route, type: :request do
  let(:starting_adress) { "Aleje Solidarności 47, Poznań, Polska" }
  let(:destination_adress) { "Pleszewska 1, Poznań, Polska" }
  let!(:route_1) { FactoryBot.create(:route)}
  let!(:route_2) { FactoryBot.create(:route)}
  let!(:route_3) { FactoryBot.create(:route, created_at: Date.today.ago(1.month))}

  before do
    Geocoder.configure(:lookup => :test)
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

    it "response has correct body" do
      get root_path

      expect(response.body).to include (route_1.distance + route_2.distance).to_s
      expect(response.body).to include route_1.created_at.strftime("%d %B")
      expect(response.body).to_not include route_3.created_at.strftime("%d %B")
    end

    it "flash alert if no routes" do
      Route.destroy_all
      get root_path

      expect(flash[:alert]).to eq "No routes for this month"
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
      it "does not create a new Route" do
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

  describe "GET /show_month" do
    it "renders a successful response" do
      get show_month_path, params: { day: Date.today }

      expect(response).to be_successful
    end

    it "response has correct body" do
      get show_month_path, params: { day: Date.today }

      expect(response.body).to include route_1.starting_adress
      expect(response.body).to include route_1.created_at.strftime("%d %B")
      expect(response.body).to_not include route_3.starting_adress
      expect(response.body).to_not include route_3.created_at.strftime("%d %B")
    end
  end
end
