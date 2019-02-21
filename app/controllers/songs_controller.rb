require "pry"
class SongsController < ApplicationController

  get '/songs' do
    @songs = Song.all
    erb :"songs/index"
  end

  get '/songs/:id' do
    erb :"songs/show"
  end

  # helper method.
  def find_song
    @song = Song.find(params[:id])
  end
end
