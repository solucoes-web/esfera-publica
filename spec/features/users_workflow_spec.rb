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
    user = create(:user)
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content("Signed in successfully.")
  end

  scenario "logout" do
    sign_in create(:user)
    visit root_path
    first(':has(.glyphicon-user)').click
    click_link "Sign out"

    expect(page).to have_current_path(new_user_session_path)
  end

  scenario "visit costumized page" do
    user = create(:user)
    sign_in user
    feed = create(:feed, users: [user])
    item = create(:item, feed: feed, name: "Titulo")

    visit root_path
    expect(page).to have_content(item.name)
  end

  scenario "visit inaccessible page" do
    user = create(:user)
    feed = create(:feed, users: [user])
    item = create(:item, feed: feed, name: "Titulo")

    visit root_path
    expect(page).to have_current_path(new_user_session_path)
  end

end
