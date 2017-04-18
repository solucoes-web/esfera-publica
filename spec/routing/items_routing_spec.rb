require "rails_helper"

RSpec.describe ItemsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/items").to route_to("items#index")
    end

  end
end
