class StaticPagesController < ApplicationController
  def home
    puts ENV['FLICKR_API_KEY']
    person = Flickr.people.find("134813803@N03")
    @photos = person.public_photos(sizes: true).map(&:medium500!)
    # Key: 4c79fdf42257f481973ffde69bfe9158
    # Secret: 3adbe02b72c4332b
    # my id: 134813803@N03
  end
end
