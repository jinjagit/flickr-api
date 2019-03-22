class StaticPagesController < ApplicationController
  require 'will_paginate/array'

  def home
  end

  def photos
    @photos = []
    person = Flickr.people.find("24448805@N07")
    @info = person.get_info!
    result = Flickr.photos.search(user_id: "24448805@N07", per_page: 100).map(&:medium500!) # max per_page = 500
    result.each do |e|
      @photos << e
    end
    @photos = @photos.paginate(page: params[:page], per_page: 10)
  end
end
