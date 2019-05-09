**Play Lister** by @flatiron

*ASSOCIATIONS*

@artist     ---<    @songs     >--<     @song_genres    >--     @genre
 name                name                song_id                 name
                     artist_id           genre_id               
                     
*RELATIONSHIPS*

An @artist has many @songs and @genres                 
A  @genre  has many @songs and @artists
A  @song belongs to one @artist and multiple @genres

A **join table** implements the relationship of:
a @song having many @genres __and__ a @genre having many @songs;
establishing a __"many-to-many"__ relationship.

You will need a *SongGenre* class to go along with this table in the database.


*ROUTES*

1. /songs
* present the user with a list of all @songs in the library.
* each @song should be a clickable link
  to that particular @song's show page.

2. /genres
* present the user with a list of all @genres in the library.
* each @genre should be a clickable link to that particular @genre's show page.

3. /artists
* present the User with a list of all @artists in the library.
* each @artist should be a clickable link
  to that particular @artist's show page.

4. /songs/:slug
Any given @song's show page should have:
* links to that @song's artist
* each @genre associated with the @song

**Pay Attention** to the order of:
```ruby

    get '/songs/new' do

    end

    get '/songs/:slug' do

    end

    # The route '/songs/new' could interpret new as a slug,
    # if that controller action isn't defined first.
```

5. /artists/:slug
Any given @artist's show page should have:
* links to each of his or her @songs and @genres.

6. /genres/:slug
Any given @genre's show page should have:
* links to each of its @artists and @songs.

To get the data into your database:
* figure out how to use your *LibraryParser* class in the
####db/seeds.rb


# APPROACH to BUILDING
Get the basics of the app working first.

In this case you have five specs to complete.
Start by passing all three model specs.

Type:
    - $ rspec spec/models/01_artist_spec.rb

*IMPORTANT* run the specs in their numeric order.
Notice even after adding a table, model, and controller
your specs are still not passing,
but the error messages are changing.

*READ* every error message carefully to understand what to do next

*NOTE* spec 05_song_form_spec.rb:
needs to implement the following features:

1. /songs/new
* Be able to create a new @song
* @genres should be presented as checkboxes
* Be able to enter the @artist's :name in a text field
  (only one @artist per @song.)

2. /songs/:slug/edit
* Be able to change everything about a @song,
  including the @genres associated with it and its @artist.

**Think about the custom writer or writers you may need to code to make these
features work**


*Fixing Migration Errors*
If you make a mistake creating databases or want to edit your migrations
use:    $ rake db:drop     to drop any tables that have been created.


*Issues with Re-Migrating*
1. delete schema.rb and any files with the extension .sqlite inside the db
   folder.
2. run      $ rake db:migrate       to recreate these files.


# *SLUGS* ('-')
Having a URL like:  
```ruby

    get /songs/1 do
        "Sucks."
    end

```
Imagine trying to email that song to a friend.
They'd have no idea what song it was until they clicked the link.
It'd be better to have a URL like:
```ruby

    get '/songs/going back to cali' do
        "#{@ERROR}: URL Can't Have Spacing!"
    end

```
In order to make it a proper URL:
* convert the spaces to hypehns ('-') in the song name.
    - This is called a slug.

A **slug** is used to create a name that is not acceptable as a URL
for various reasons (special characters, spaces, etc).

Instead of having a route like:
```ruby

    get '/songs/1' do
        "Sucks."
    end

    # you can have a route like:

    get '/songs/going-back-to-cali' do
        "Much Better and More Descriptive!"
    end

```
#Each class built will need:
1. a method to #slugify each @object's name.

#This means you'll need to:
1. strip out any special characters
2. replace all spaces with a hyphen ('-')

#Build a #slug method which:
1. takes a given song/artist/genre name
2. creates the "slugified" version

#Build a #find_by_slug method that:
1. use the #slug to retrieve a song/artist/genre from the db
2. return that entry


*CHECK BOXES*
#Create a check box of all the genres on a new song form by:
1. iterating over all the @genres in the database,
#In the <input /> tag:
2. setting the genre.name as the ID of the input tag:
   * id="<%= genre.name %>"
3. the value attribute should be set to the genre.id
   * value="<%= genre.id %>"
4. the name attribute should be set to genres[] because we're dealing with a
   collection of attributes.
   * name="genre[]"

The params hash look like this:

params = {
    @genres => [ @genre1, @genre2, @genre2]
}

####views/songs/new
```html

<% @genres.each do |genre| %>
    <input id="<%= genre.name %>" type="checkbox" name="genres[]" value="<%= genre.id %>">
<% end %>

```

*FLASH MESSAGE*
#To display this message in the view, add to top of the view:

####views/songs/show.erb
<% if flash.has?(:message) %>
  <%= flash[:message] %>
<% end %>


*LIBRARY PARSER*
The **LibraryParser** class should be responible for:
1. finding the MP3 files
2. parsing their titles
3. and building Song, Artist, and Genre objects from that data.

The 'library_parser_spec' defines a pretty specific vision for the library parser.
It breaks it down to some small methods.

### METHODS:

#files => returns an array of file names
Sets a @files variables equal to the list of files contained in the db/data directory;
via the following line:
```ruby
        data_path = File.join(File.dirname(__FILE__), '..', 'db', 'data')
```
The **Dir** class is a Ruby class that provides a variety of ways to list directories and their
contents via:
```ruby
        Dir.entries(data_path)[2..-1]
```
1. require 'pry' at the top of the *LibraryParser* file
2. place a binding.pry into the .files method
3. take a look at the @files variable; become familiar with the array you'll be
   operating on.

#self.parse

#parse_filename(filename) => returns an array: [artist_name, song_name, genre_name]
This methods implementation is important to understand.

- it operates on a single file name.
- takes in a file name as an argument and extracts from that file:
    * author
    * song
    * genre
- returns an array that looks like this: *[artist_name, song_name, genre_name]*

Inside '.parse_filename' you're operating on an individual file name,
which looks something like this: "db/data/Lost Boyz - Lex Coupe Bimaz Benz - hiphop.mp3"

You must extract just the:
    * artist name
    * song name
    * genre name

1. Get rid of the "db/data" and .mp3 bits that start and end the string.
2. Chop off the first part using the .slice method:
    * filename.slice!(0..7)

Now our file name looks something like this: "Lost Boyz - Lex Coupe Bimaz Benz - hiphop.mp3"

3. Get rid of the file extension now:
    * filename.slice!(-4..-1)

Splitting the string on the ' - ' will get the array you want:
    * filename.split(" - ")
    * the return value would look this this: *["Lost Boyz", "Lex Coupe Bimaz Benz", "hiphop"]*
    * successfully returning the array:      [artist_name,        song_name,       genre_name]

#build_objects(artist_name, song_name, genre_name)
1. takes in an argument of an individual file name
2. creates a @song instance

Call:
* #create on **Song** to instantiate the @artist, @song and @genre.
* #find_or_create_by() on **Genre** and **Artist** to either find/add @genre || @artist.
* #song_genres.build on @song to associate a @genre.
* #artist on @song to associate an @artist.

Make sure this method returns the @song instance that you create.

#call
responsible for executing the *LibraryParser* code.
1. iterates over the array of file names stored in #files
2. for each file name:
    * stores the result of #parse_filename(filename) in a local variable = parts
    * passes that result to #build_objects(parts) to create a @song.
