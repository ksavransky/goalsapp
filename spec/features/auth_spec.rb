require 'spec_helper'
require 'rails_helper'



feature "the signup process" do

  scenario "has a new user page" do
    visit new_user_url
    expect(page).to have_content("New user")
  end

  feature "signing up a user" do

    before(:each) do
      visit new_user_url
      fill_in("Username", with: "Bobbbbb")
      fill_in("Password", with: "lots_of_bees")
      click_button("Sign up")
    end

    scenario "shows username on the homepage after signup" do
      expect(page).to have_content("Bobbbbb")
    end

  end

end

feature "logging in" do
  before(:each) do
    create_and_log_in_as_bob
  end

  scenario "shows username on the homepage after login" do
    expect(page).to have_content("Bobbbbb")
  end

end

feature "logging out" do

  scenario "begins with logged out state" do
    visit root_url
    expect(page).to have_content("Sign in")
  end

  scenario "doesn't show username on the homepage after logout" do
    create_and_log_in_as_bob
    click_button("Log out")
    expect(page).not_to have_content("Bobbbbb")
  end

end
