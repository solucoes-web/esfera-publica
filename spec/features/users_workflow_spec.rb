require 'rails_helper'

RSpec.feature "UserWorkflows", type: :feature do
  scenario "sign up" do
    visit signup_path

    fill_in email, with: 'foo@bar.com'
    fill_in password, with: 'password'
    expect do
      click_in 'Sign up'
    end.to change{ User.count }.by 1
  end

  scenario "login" do
    login

    expect(page).to have_content("sucesso")
  end

  scenario "logout" do
    login
    click_link "logout"

    expect(page).to have_content("sucesso")
  end

  scenario "visit costumized page" do
    user = login
    (feed = build(:feed, user: user)).save(validate: false)
    item = create(:item, feed: feed, name: "Titulo")

    visit root_path
    expect(page).to have_content(item.name)
  end

  scenario "visit inaccessible page" do
    user = create(:user)
    (feed = build(:feed, user: user)).save(validate: false)
    item = create(:item, feed: feed, name: "Titulo")

    visit root_path
    expect(page).not_to have_content(item.name)
  end

end
