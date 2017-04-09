require 'rails_helper'

RSpec.describe "items/index", type: :view do
  before(:each) do
    assign(:search, Item)
    @items = (1..2).map{ build_stubbed(:item) }
    assign(:items, @items)
  end

  it "renders a list of items" do
    render
    @items.each do |item|
      assert_select "li .item-title", text: item.name, href: item.url
      assert_select "li .item-summary", text: item.summary
    end
  end
end
