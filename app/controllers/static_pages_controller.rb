class StaticPagesController < ApplicationController
  require 'will_paginate/array'

  def home
  end

  def photos
    @photos = []
    person = Flickr.people.find("24448805@N07")
    @info = person.get_info!
    total_photos = @info.photos_count
    pages = (total_photos / 500.floor) + 1

    pages.times do |i|
      page_n = i + 1
      result = Flickr.photos.search(user_id: "24448805@N07", page: page_n, per_page: 500).map(&:medium500!) # max per_page = 500
      result.each do |e|
        @photos << e
      end
    end

    @total = @photos.length
    @photos = @photos.paginate(page: params[:page], per_page: 100)
  end
end
