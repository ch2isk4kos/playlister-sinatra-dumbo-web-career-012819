class Genre < ActiveRecord::Base
    has_many :song_genres
    has_many :songs, through: :song_genres
    has_many :artists, through: :songs

    # This code is repetitive
    # It's important to keep your code D-R-Y (Don't Repeat Yourself)
    # To fix that you could put these methods inside a module.
    # For a full breakdown, see: /app/models/artist.rb

    def slug
        self.name.gsub(/\s/, "-").downcase
    end

    def self.find_by_slug(slug)
        Genre.all.find { |genre| genre.slug == slug }
    end

end
