class Artist < ActiveRecord::Base
    has_many :songs
    has_many :genres, through: :songs

    def slug
        self.name.gsub(/\s/, "-").downcase

        #name gets called on Artist     => "The Notorious B.I.G"
        #gsub is called on Artist.name  => "The Notorious B.I.G".gsub.downcase
                                       #=> "the-notorious-b-i-g"
    end

    def self.find_by_slug(slug)
        Artist.all.find {|artist| artist.slug == slug}

        # takes in an argument of an Artist.name

        #all   => called on Artist (which is an array of @artists)
        #find  => called on Artist.all to iterate over the @artists array

        # the @artist is found in the array     => "The Notorious B.I.G"
        # by matching the returned artist.slug  => "the-notorious-b-i-g"
        # to the slug passed in .find_by_slug(slug) as an argument
    end

    # 1ST ATTEMPT
    # def find_by_slug(artist_name)
    #     artist_name = Artist.find_or_create_by(params[:id])
    #     artist_name.slug.name
    # end
end
