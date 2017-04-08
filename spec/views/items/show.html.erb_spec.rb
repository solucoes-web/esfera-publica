require 'rails_helper'

RSpec.describe "items/show", type: :view do
  before(:each) do
    @item = build_stubbed(:item)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/#{@item.name}/)
    expect(rendered).to match(/#{@item.summary}/)
    expect(rendered).to match(/#{@item.url}/)
  end
end
