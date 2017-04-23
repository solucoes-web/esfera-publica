require 'rails_helper'

RSpec.describe "Feeds", type: :request do
  describe "Unautorized feeds access" do
    after :each do
      expect(response).to redirect_to new_user_session_path
    end

    it 'should deny access to root path' do
      get root_path
    end

    it "should deny access to feeds list" do
      get feeds_path
    end

    it "should deny access to new feed" do
      get new_feed_path
    end

    it "should deny access to create feed" do
      post feeds_path, params: {feed: {url: 'http://example.com'}}
    end

    it "should deny access to edit feed" do
      get edit_feed_path create(:feed)
    end

    it "should deny access to update feed" do
      put feed_path(create(:feed)), params: {feed: {tag: 'TAG'}}
    end

    it "should deny access to destroy feed" do
      delete feed_path(create(:feed))
    end
  end

  describe "Authorized feeds access" do
    before :each do
      @user = create(:user)
      sign_in @user
    end

    it "should successfully access feed's index" do
      get feeds_path
      expect(response).to have_http_status(200)
    end

    it "should successfully access root path" do
      get root_path
      expect(response).to have_http_status(200)
    end

    it "should successfully access new feed's page" do
      get new_feed_path
      expect(response).to have_http_status(200)
    end

    it "should successfully create feed" do
      url = 'http://example.com'
      mock_request(url)
      allow_any_instance_of(Feed).to receive(:valid?).and_return true

      expect{
         post feeds_path, params: {feed: {url: url}}
      }.to change{Feed.count}.by 1
      expect(response).to redirect_to feeds_path
    end

    it "should successfully access edit feed's page" do
      get edit_feed_path create(:feed)
      expect(response).to have_http_status(200)
    end

    it "should successfully update feed" do
      allow_any_instance_of(Feed).to receive(:valid?).and_return true
      feed = create(:feed)
      expect{
        put feed_path(create(:feed)), params: {feed: {tag_list: 'TAG'}}
      }.to change{@user.owned_tags.count}.by 1
      expect(response).to redirect_to feeds_path
    end

    it "should successfully destroy feed" do
      feed = create(:feed)
      expect{
        delete feed_path feed
      }.to change{Feed.count}.by -1
      expect(response).to redirect_to feeds_path
    end

  end
end
