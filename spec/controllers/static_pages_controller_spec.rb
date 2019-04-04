require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
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
        post :info, params: { find_by: { id: "24448805@N07" } }
        expect(response).to have_http_status "200"
      end
    end

    context "when valid Flickr username submitted" do
      it "returns a 200 response" do
        post :info, params: { find_by: { username: "Tony Shi Photos" } }
        expect(response).to have_http_status "200"
      end
    end

    context "when invalid Flickr id submitted" do
      it "redirects to root (find page)" do
        post :info, params: { find_by: { id: "1234" } }
        expect(response).to redirect_to root_path
      end
    end

    context "when invalid Flickr username submitted" do
      it "redirects to root (find page)" do
        post :info, params: { find_by: { username: "non-existant username" } }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#albums" do
    context "when passed a valid Flickr user id" do
      it "returns a 200 response" do
        post :albums, params: { show: { user_id: "24448805@N07" } }
        expect(response).to have_http_status "200"
      end
    end
  end

  describe "#album" do
    context "when passed valid Flickr user id, album title, and set id" do
      it "returns a 200 response" do
        post :album, params: { album: { set_id: "72157606319933770",
          title: "New York", user_id: "24448805@N07" } }
        expect(response).to have_http_status "200"
      end
    end
  end

  describe "#photos" do
    context "when passed valid Flickr user id" do
      it "returns a 200 response" do
        post :photos, params: { show: { user_id: "24448805@N07" } }
        expect(response).to have_http_status "200"
      end
    end
  end
end
