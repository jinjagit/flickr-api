class StaticPagesController < ApplicationController
  require 'will_paginate/array'

  def home
  end

  def photos
    id = params[:find_by][:id]
    puts "id: #{id}"
    @photos = []
    person = Flickr.people.find(id)
    @info = person.get_info!
    total_photos = @info.photos_count
    pages = (total_photos / 500.floor) + 1

    pages.times do |i|
      page_n = i + 1
      result = Flickr.photos.search(user_id: id, page: page_n, per_page: 500).map(&:medium500!) # max per_page = 500
      result.each do |e|
        @photos << e
      end
    end

    @total = @photos.length
    @photos = @photos.paginate(page: params[:page], per_page: 100)
  end

  # nice photos @ id: "24448805@N07"
end
