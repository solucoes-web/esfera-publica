require 'rails_helper'

RSpec.describe "items/index", type: :view do
  before(:each) do
    @items = (1..2).map{ build_stubbed(:item) }
    assign(:items, @items )
  end

  it "renders a list of items" do
    render
    @items.each do |item|
      assert_select "tr>td", :text => item.name
      assert_select "tr>td", :text => item.summary
      assert_select "tr>td", :text => item.url
      assert_select "tr>td", :text => item.guid
    end
  end
end
