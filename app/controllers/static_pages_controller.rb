class StaticPagesController < ApplicationController
  require 'will_paginate/array'

  def home
  end

  def info
    begin
      if params[:find_by].key?("id")
        person = Flickr.people.find(params[:find_by][:id])
      elsif params[:find_by].key?("username")
        raise NoMethodError if params[:find_by][:username] == '' # Flickr user exists with username == '', but has no photos!
        person = Flickr.people.find_by_username(params[:find_by][:username])
      end

      @sets = person.get_sets
      @info = person.get_info!

    rescue StandardError => e
      if params[:find_by][:id] == ''
        form_error("Error: user ID cannot be blank")
      elsif params[:find_by][:username] == ''
        form_error("Error: username cannot be blank")
      else
        form_error("#{e.class}: #{e.message}")
      end
    end
  end

  def photos
    id = params[:show][:user_id]
    person = Flickr.people.find(id)
    @info = person.get_info!
    count = @info.photos_count
    get_photos(count, &lambda{|p| return Flickr.photos.search(user_id: id, page: p, per_page: 500).map(&:medium500!)})
  end

  def albums
    @id = params[:show][:user_id]
    person = Flickr.people.find(@id)
    @sets = person.get_sets
  end

  def album
    @title = params[:album][:title]
    person = Flickr.people.find(params[:album][:user_id])
    sets = person.get_sets
    set = sets.detect {|e| e.title == @title}
    count = set.photos_count
    get_photos(count, &lambda{|p| return set.get_photos(page: p, per_page: 500).map(&:medium500!)})
  end

  private

    def form_error(error)
      flash[:error] = error
      redirect_to root_path
    end

    def get_photos(count, &api_search)
      @photos = []
      pages = (count / 500.floor) + 1

      pages.times do |i|
        page_n = i + 1
        result = yield(page_n)
        result.each do |e|
          @photos << e
        end
      end

      @photos = @photos.paginate(page: params[:page], per_page: 100)
    end
end
