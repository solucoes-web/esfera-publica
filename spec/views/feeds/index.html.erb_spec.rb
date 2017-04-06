require 'rails_helper'

RSpec.describe "feeds/index", type: :view do
  before(:each) do
    assign(:feeds, (1..2).map{ build_stubbed(:feed) })
  end

  it "renders a list of feeds" do
    render
    assert_select "tr td", :text => "Name".to_s, :count => 2
  end
end
