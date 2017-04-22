require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  it "formats date" do
    expect(default_date_format 2.days.ago).to eq "2 dias"
    expect(default_date_format 2.hours.ago).to eq "2 horas"
  end

  pending "link_to_filter"
  pending "link_to_tag_filter"
  pending "link_to_interaction_filter"
  pending "link_to_clear_filter"
end
