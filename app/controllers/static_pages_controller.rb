class StaticPagesController < ApplicationController
  require 'will_paginate/array'

  def home
  end

  def info
    @photos = []
    id = ''

    if params[:find_by].key?("id")
      id = params[:find_by][:id]
      person = Flickr.people.find(id)
    elsif params[:find_by].key?("username")
      person = Flickr.people.find_by_username(params[:find_by][:username])
      id = person.id
    else
      puts "No details provided" # PLUS error handling!
    end

    @sets = person.get_sets # what happens if no sets?
    @info = person.get_info!
  end

  def photos
    @photos = []
    @id = params[:show][:user_id]
    person = Flickr.people.find(@id)
    @info = person.get_info!

    total_photos = @info.photos_count
    pages = (total_photos / 500.floor) + 1

    pages.times do |i|
      page_n = i + 1
      result = Flickr.photos.search(user_id: @id, page: page_n, per_page: 500).map(&:medium500!) # max per_page = 500
      result.each do |e|
        @photos << e
      end
    end

    @photos = @photos.paginate(page: params[:page], per_page: 100)
  end

  def albums
    @id = params[:show][:user_id]
    person = Flickr.people.find(@id)
    @sets = person.get_sets
  end

  def album
    @photos = []
    @title = params[:album][:title]
    @id = params[:album][:user_id]
    person = Flickr.people.find(@id)
    sets = person.get_sets
    set = sets.detect {|e| e.title == @title}

    total_photos = set.photos_count
    pages = (total_photos / 500.floor) + 1

    pages.times do |i|
      page_n = i + 1
      result = set.get_photos(page: page_n, per_page: 500).map(&:medium500!) # max per_page = 500
      result.each do |e|
        @photos << e
      end
    end

    @photos = @photos.paginate(page: params[:page], per_page: 100)
  end
end
