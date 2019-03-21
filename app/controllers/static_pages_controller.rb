class StaticPagesController < ApplicationController
  def home
    person = Flickr.people.find("134813803@N03")
    @photos = person.public_photos(per_page: 500, sizes: true).map(&:medium500!)
    @info = person.get_info!
  end
end
