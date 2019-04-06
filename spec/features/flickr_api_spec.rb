require 'rails_helper'

RSpec.feature "Flickr API features", type: :feature do
  before do
    @valid_id = "24448805@N07"
    @valid_username = "Tony Shi Photos"
    @valid_set_id = "72157606319933770"
    @photo1_p1_all = "https://farm8.staticflickr.com/7927/46732646452_40b1fdc1aa.jpg"
    @photo100_p1_all = "https://farm5.staticflickr.com/4690/38441000915_67043f79cc.jpg"
    @photo1_p2_all = "https://farm5.staticflickr.com/4633/38559503184_555914fb01.jpg"
    @photo100_p2_all = "https://farm5.staticflickr.com/4162/34540783475_8b93f2f666.jpg"
    @photo1_p4_all = "https://farm6.staticflickr.com/5700/30817213896_9117681388.jpg"
    @photo100_p4_all = "https://farm2.staticflickr.com/1513/25720626372_a34b3c705e.jpg"
    @photo1_p1_NY = "https://farm9.staticflickr.com/8001/7669801864_8e92299b58.jpg"
    @photo100_p1_NY = "https://farm9.staticflickr.com/8478/8248220191_8427215fc1.jpg"
    @photo1_p10_NY = "https://farm4.staticflickr.com/3940/33400551840_95057447e5.jpg"
    @photo58_p10_NY = "https://farm8.staticflickr.com/7908/31936866997_6cc3b82c52.jpg"
    @page4_all = "/photos?commit=view+all+photos&page=4&show%5Buser_id%5D=24448805%40N07&utf8=%E2%9C%93"
    @page10_NY = "/album?album%5Bset_id%5D=72157606319933770&album%5Btitle%5D=New+York&album%5Buser_id%5D=24448805%40N07&commit=view+album&page=10&utf8=%E2%9C%93"
    @invalid_id = "123"
    @invalid_username = "this username does not exist"
  end

  describe "Flickr user search (home page) returns user info" do
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
  end

  describe "Flickr user search (home page) does not return user info" do
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

  describe "Photos display correctly (all photos path)" do
    before do
      VCR.use_cassette('correct_ID_search') do
        visit root_path
        fill_in "find_by_id", with: @valid_id
        click_button "find by user ID"
      end
      VCR.use_cassette('valid_photos_request') do
        click_button "view all photos"
      end
    end

    scenario "when click 'view all photos'" do
        expect(page).to have_content "All photos:"
        expect(page).to have_css('img', count: 200)
        expect(page).to have_css("img[src*='#{@photo1_p1_all}']")
        expect(page).to have_css("img[src*='#{@photo100_p1_all}']")
    end

    scenario "when click 'next' page (photos page - all photos)" do
      VCR.use_cassette('next_page_all_photos_request') do
        find(".next_page", :match => :first).click
        expect(page).to have_content "All photos:"
        expect(page).to have_css('img', count: 200)
        expect(page).to have_css("img[src*='#{@photo1_p2_all}']")
        expect(page).to have_css("img[src*='#{@photo100_p2_all}']")
      end
    end

    scenario "when click 'previous' page (photos page - all photos)" do
      VCR.use_cassette('next_page_all_photos_request') do
        find(".next_page", :match => :first).click
      end
      VCR.use_cassette('previous_page_all_photos_request') do
        find(".previous_page", :match => :first).click
        expect(page).to have_content "All photos:"
        expect(page).to have_css('img', count: 200)
        expect(page).to have_css("img[src*='#{@photo1_p1_all}']")
        expect(page).to have_css("img[src*='#{@photo100_p1_all}']")
      end
    end

    scenario "when click page '4' (photos page - all photos)" do
      VCR.use_cassette('page_4_all_photos_request') do
        find(:xpath, "//a[@href='#{@page4_all}']", :match => :first).click
        expect(page).to have_content "All photos:"
        expect(page).to have_css('img', count: 200)
        expect(page).to have_css("img[src*='#{@photo1_p4_all}']")
        expect(page).to have_css("img[src*='#{@photo100_p4_all}']")
      end
    end
  end

  describe "Photos display correctly (album path)" do
    before do
      VCR.use_cassette('correct_ID_search') do
        visit root_path
        fill_in "find_by_id", with: @valid_id
        click_button "find by user ID"
      end
      VCR.use_cassette('valid_albums_search') do
        click_button "view album(s)"
      end
    end

    scenario "when click 'view album(s)'" do
      expect(page).to have_content "Albums:"
      expect(page).to have_content "California"
    end

    scenario "when click specific album 'New York'" do
      VCR.use_cassette('valid_album_request') do
        find(".btn", :match => :first).click
        expect(page).to have_content "New York"
        expect(page).to have_css("img[src*='#{@photo1_p1_NY}']")
        expect(page).to have_css("img[src*='#{@photo100_p1_NY}']")
      end
    end

    scenario "when click page '10' (photos page - 'New York' album)" do
      VCR.use_cassette('valid_album_request') do
        find(".btn", :match => :first).click
      end
      VCR.use_cassette('page_10_NY_album_request') do
        find(:xpath, "//a[@href='#{@page10_NY}']", :match => :first).click
        expect(page).to have_css('img', count: 116)
        expect(page).to have_css("img[src*='#{@photo1_p10_NY}']")
        expect(page).to have_css("img[src*='#{@photo58_p10_NY}']")
      end
    end
  end
end
