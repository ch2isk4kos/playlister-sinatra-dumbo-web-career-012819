class Song < ActiveRecord::Base
        belongs_to :artist
        has_many :song_genres
        has_many :genres, through: :song_genres

        # This code is repetitive
        # It's important to keep your code D-R-Y (Don't Repeat Yourself)
        # To fix that you could put these methods inside a module.
        # For a full breakdown, see: /app/models/artist.rb

        def slug
            name.downcase.gsub(" ","-")
        end

        def self.find_by_slug(slug)
            Song.all.find { |song| song.slug == slug }
        end
end
