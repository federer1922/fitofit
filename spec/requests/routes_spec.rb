require "rails_helper"

RSpec.describe Route, type: :request do
  let(:starting_adress) { "Aleje Solidarności 47, Poznań, Polska" }
  let(:destination_adress) { "Pleszewska 1, Poznań, Polska" }
  let!(:route_1) { FactoryBot.create(:route, created_at: Date.today)}
  let!(:route_2) { FactoryBot.create(:route, created_at: Date.today)}
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
      get root_path, params: { month: Date.today.since(1.month) }

      expect(flash[:alert]).to eq "No routes for this month"
    end

    it "shows routes for previous month" do
      get root_path, params: { month: Date.today.ago(1.month) }

      expect(response.body).to include route_3.distance.to_s
      expect(response.body).to include route_3.created_at.strftime("%d %B")
      expect(response.body).to_not include route_1.created_at.strftime("%d %B")
    end


  end

  describe "GET /create" do
    context "with valid parameters" do
      it "creates a new Route" do
        expect {
          post create_path, params: { starting_adress: starting_adress, destination_adress: destination_adress }
        }.to change(Route, :count).by(1)
      end

      it "redirects to root_path" do
        post create_path, params: { starting_adress: starting_adress, destination_adress: destination_adress }
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Route" do
        expect {
          post create_path, params: { starting_adress: starting_adress, destination_adress: nil }
        }.to change(Route, :count).by(0)
      end

      it "redirects to root_path with error" do
        post create_path, params: { starting_adress: starting_adress, destination_adress: nil }

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

  describe "GET /show_day" do
    it "renders a successful response" do
      get show_day_path, params: { day: Date.today }

      expect(response).to be_successful
    end

    it "response has correct body" do
      get show_day_path, params: { day: Date.today }

      expect(response.body).to include route_1.starting_adress
      expect(response.body).to include route_1.distance.to_s
      expect(response.body).to_not include route_3.starting_adress
    end
  end

  describe "delete /destroy" do
    it "destroys the requested route for show month" do
      get show_month_path, params: { day: Date.today }

      expect {
        delete destroy_path, params: { route_id: route_1.id }
      }.to change(Route, :count).by(-1)
    end

    it "redirects to show month" do
      get show_month_path, params: { day: Date.today }
      delete destroy_path, params: { route_id: route_1.id, click_source: "show_month_details" }

      expect(response).to redirect_to(show_month_path)
      expect(flash[:notice]).to eq "Route successfully deleted"
    end

    it "redirects to root path with month alert" do
      get show_month_path, params: { day: Date.today.ago(1.month) }
      delete destroy_path, params: { route_id: route_3.id, click_source: "show_month_details" }

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq "No routes for this month, back to the main site"
    end

    it "destroys the requested route for show day" do
      get show_day_path, params: { day: Date.today }

      expect {
        delete destroy_path, params: { route_id: route_1.id }
      }.to change(Route, :count).by(-1)
    end

    it "redirects to show day" do
      get show_day_path, params: { day: Date.today }
      delete destroy_path, params: { route_id: route_1.id }

      expect(response).to redirect_to(show_day_path)
      expect(flash[:notice]).to eq "Route successfully deleted"
    end

    it "redirects to root path with day alert" do
      get show_day_path, params: { day: Date.today.ago(1.month) }
      delete destroy_path, params: { route_id: route_3.id }

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq "No routes for this day, back to the main site"
    end
  end

  describe "GET /edit_month" do
    it "renders a successful response" do
      get edit_month_path, params: { route_id: route_1.id }

      expect(response).to be_successful
    end

    it "response has correct body" do
      get edit_month_path, params: { route_id: route_1.id }

      expect(response.body).to include route_1.starting_adress
      expect(response.body).to include route_1.destination_adress
    end
  end

  describe "GET /update_month" do
    it "updates route" do
      put update_month_path, params: { route_id: route_1.id, starting_adress: starting_adress, destination_adress: destination_adress }

      expect(route_1.reload.starting_adress).to eq starting_adress
      expect(route_1.reload.destination_adress).to eq destination_adress
      expect(flash[:notice]).to eq "Route successfully updated"
    end

    it "doesn't upadate route with invalid paramas" do
      put update_month_path, params: { route_id: route_1.id, starting_adress: nil }

      expect(flash[:alert]).to eq "Starting adress can't be blank"
    end
  end

  describe "GET /edit_day" do
    it "renders a successful response" do
      get edit_day_path, params: { route_id: route_1.id }

      expect(response).to be_successful
    end

    it "response has correct body" do
      get edit_day_path, params: { route_id: route_1.id }

      expect(response.body).to include route_1.starting_adress
      expect(response.body).to include route_1.destination_adress
    end
  end

  describe "GET /update_day" do
    it "updates route" do
      put update_day_path, params: { route_id: route_1.id, starting_adress: starting_adress, destination_adress: destination_adress }

      expect(route_1.reload.starting_adress).to eq starting_adress
      expect(route_1.reload.destination_adress).to eq destination_adress
      expect(flash[:notice]).to eq "Route successfully updated"
    end

    it "doesn't upadate route with invalid paramas" do
      put update_day_path, params: { route_id: route_1.id, starting_adress: nil }

      expect(flash[:alert]).to eq "Starting adress can't be blank"
    end
  end
end
