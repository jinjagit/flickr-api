require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  before do
    @valid_id = "24448805@N07"
    @valid_username = "Tony Shi Photos"
    @valid_set_id = "72157606319933770"
    @invalid_id = "123"
    @invalid_username = "this username does not exist"
  end

  describe "#home" do
    it "responds successfully" do
      get :home
      expect(response).to be_successful
    end

    it "returns a 200 response" do
      get :home
      expect(response).to have_http_status "200"
    end
  end

  describe "#info" do
    context "when valid Flickr id submitted" do
      it "returns a 200 response" do
        VCR.use_cassette('correct_ID_search') do
          post :info, params: { find_by: { id: @valid_id } }
          expect(response).to have_http_status "200"
        end
      end
    end

    context "when valid Flickr username submitted" do
      it "returns a 200 response" do
        VCR.use_cassette('correct_username_search') do
          post :info, params: { find_by: { username: @valid_username } }
          expect(response).to have_http_status "200"
        end
      end
    end

    context "when invalid Flickr id submitted" do
      it "redirects to root (find page)" do
        VCR.use_cassette('invalid_ID_search') do
          post :info, params: { find_by: { id: @invalid_id } }
          expect(response).to redirect_to root_path
        end
      end
    end

    context "when invalid Flickr username submitted" do
      it "redirects to root (find page)" do
        VCR.use_cassette('invalid_username_search_search') do
          post :info, params: { find_by: { username: @invalid_username } }
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe "#albums" do
    context "when passed a valid Flickr user id" do
      it "returns a 200 response" do
        VCR.use_cassette('valid_albums_search') do
          post :albums, params: { show: { user_id: @valid_id } }
          expect(response).to have_http_status "200"
        end
      end
    end
  end

  describe "#album" do
    context "when passed valid Flickr user id, album title, and set id" do
      it "returns a 200 response" do
        VCR.use_cassette('valid_album_request') do
          post :album, params: { album: { set_id: @valid_set_id,
            title: "New York", user_id: @valid_id } }
          expect(response).to have_http_status "200"
        end
      end
    end
  end

  describe "#photos" do
    context "when passed valid Flickr user id" do
      it "returns a 200 response" do
        VCR.use_cassette('valid_photos_request') do
          post :photos, params: { show: { user_id: @valid_id } }
          expect(response).to have_http_status "200"
        end
      end
    end
  end
end
