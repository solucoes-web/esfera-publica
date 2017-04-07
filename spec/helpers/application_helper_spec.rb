require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  it "formats date" do
    date = DateTime.new(2017, 4, 3, 13, 30, 0)
    expect(default_date_format date).to eq "03/04/17 13:30"
  end
end
