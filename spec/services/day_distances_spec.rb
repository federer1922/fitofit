require "rails_helper"

RSpec.describe "day distances" do
  let!(:route_1) { FactoryBot.create(:route, created_at: Date.today.beginning_of_month, distance: 3) }
  let!(:route_2) { FactoryBot.create(:route, created_at: Date.today.beginning_of_month, distance: 4) }
  let!(:route_3) { FactoryBot.create(:route, created_at: Date.today.end_of_month, distance: 2) }

  it "sums day distances for present month" do
    date = Date.today
    routes = Route.where(created_at: date.beginning_of_month..date.end_of_month)
    routes_sum = DayDistances.call(routes)

    expect(routes_sum).to eq "#{date.beginning_of_month.strftime("%-d %B")}"=>7, "#{date.end_of_month.strftime("%-d %B")}"=>2
  end
end