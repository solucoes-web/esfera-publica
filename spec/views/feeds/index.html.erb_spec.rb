require 'rails_helper'

RSpec.describe "feeds/index", type: :view do
  before(:each) do
    assign(:feeds, [
      Feed.create!(
        :name => "Name",
        :url => "Url",
        :favicon => "Favicon"
      ),
      Feed.create!(
        :name => "Name",
        :url => "Url",
        :favicon => "Favicon"
      )
    ])
  end

  it "renders a list of feeds" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    assert_select "tr>td", :text => "Favicon".to_s, :count => 2
  end
end
