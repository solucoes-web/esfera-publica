require 'rails_helper'

RSpec.describe "items/edit", type: :view do
  before(:each) do
    @item = assign(:item, build_stubbed(:item))
  end

  it "renders the edit item form" do
    render

    assert_select "form[action=?][method=?]", item_path(@item), "post" do

      assert_select "input#item_name[name=?]", "item[name]"

      assert_select "textarea#item_summary[name=?]", "item[summary]"

      assert_select "input#item_url[name=?]", "item[url]"

      assert_select "input#item_guid[name=?]", "item[guid]"

      assert_select "input#item_feed[name=?]", "item[feed]"
    end
  end
end
