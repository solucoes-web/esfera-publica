require 'rails_helper'

RSpec.describe "items/show", type: :view do
  before(:each) do
    @it = build_stubbed(:item)
    @item = assign(:item, @it)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/#{@it.name}/)
    expect(rendered).to match(/#{@it.summary}/)
    expect(rendered).to match(/#{@it.url}/)
  end
end
