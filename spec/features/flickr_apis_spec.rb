require 'rails_helper'

RSpec.feature "Flickr API features", type: :feature do
  before do
    # 'Valid' details dependent on the chosen example Flickr user existing
    @valid_id = "24448805@N07"
    @valid_username = "Tony Shi Photos"
    @invalid_id = "123"
    @invalid_username = "this username does not exist"
  end

  describe "Flickr user search (home page)" do
    scenario "when valid Flickr user ID submitted" do
      VCR.use_cassette('correct_ID_search') do
        visit root_path
        fill_in "find_by_id", with: @valid_id
        click_button "find by user ID"

        expect(page).to have_content "Flickr user:"
        expect(page).to have_content "username: #{@valid_username}"
        expect(page).to have_current_path(info_path, only_path: true)
      end
    end

    scenario "when valid Flickr username submitted" do
      VCR.use_cassette('correct_username_search') do
        visit root_path
        fill_in "find_by_username", with: @valid_username
        click_button "find by username"

        expect(page).to have_content "Flickr user:"
        expect(page).to have_content "username: #{@valid_username}"
        expect(page).to have_current_path(info_path, only_path: true)
      end
    end

    scenario "when invalid Flickr user ID submitted" do
      VCR.use_cassette('invalid_ID_search') do
        visit root_path
        fill_in "find_by_id", with: @invalid_id
        click_button "find by user ID"

        expect(page).to have_content "Flickr::ApiError: 1: User not found"
        expect(page).to have_current_path(root_path)
      end
    end

    scenario "when invalid Flickr username submitted" do
      VCR.use_cassette('invalid_username_search') do
        visit root_path
        fill_in "find_by_username", with: @invalid_username
        click_button "find by username"

        expect(page).to have_content "Flickr::ApiError: 1: User not found"
        expect(page).to have_current_path(root_path)
      end
    end

    scenario "when blank Flickr user ID submitted" do
      visit root_path
      fill_in "find_by_id", with: ""
      click_button "find by user ID"

      expect(page).to have_content "Error: user ID cannot be blank"
      expect(page).to have_current_path(root_path)
    end

    scenario "when blank Flickr username submitted" do
      visit root_path
      fill_in "find_by_username", with: ""
      click_button "find by username"

      expect(page).to have_content "Error: username cannot be blank"
      expect(page).to have_current_path(root_path)
    end
  end
end
