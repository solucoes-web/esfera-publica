require 'rails_helper'

RSpec.feature "UserWorkflows", type: :feature do
  before :each do
    clean_db
  end

  scenario "sign up" do
    visit new_user_registration_path

    fill_in 'Email', with: 'foo@bar.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'

    expect do
      click_on 'Sign up'
    end.to change{ User.count }.by 1
  end

  scenario "login" do
    login

    expect(page).to have_content("Signed in successfully.")
  end

  scenario "logout" do
    login
    first(':has(.glyphicon-user)').click
    click_link "Logout"

    expect(page).to have_content("Signed out successfully")
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
