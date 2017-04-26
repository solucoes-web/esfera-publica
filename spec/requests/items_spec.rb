require 'rails_helper'

RSpec.describe "Items", type: :request do
  describe "Unautorized items access" do
    after :each do
      expect(response).to redirect_to new_user_session_path
    end

    it "should deny access to items list" do
      get items_path
    end

    it "should deny access to view item" do
      get item_path create(:item)
    end

    it "should deny access to interact with item" do
      patch interact_path(create(:item)), params: {favourite: true}
    end
  end

  describe "Authorized items access" do
    before :each do
      @user = create(:user)
      sign_in @user
    end

    it "should successfully access item's index" do
      get items_path
      expect(response).to have_http_status(200)
    end

    it "should successfully access show item's page" do
      get item_path create(:item)
      expect(response).to have_http_status(200)
    end

    it "should successfully update item" do
      item = create(:feed)
      expect{
        patch interact_path(create(:item)), params: {favourite: true}
      }.to change{@user.favourites.count}.by 1
      expect(response).to redirect_to items_path
    end

  end
end
