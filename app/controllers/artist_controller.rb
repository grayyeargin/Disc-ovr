class ArtistController < ApplicationController

	def index
		query = params[:query]
		query = query.gsub(' ', '%20')
		artist_api_response = HTTParty.get("https://api.spotify.com/v1/search?q=#{query}&type=artist")
		@artist_image = artist_api_response["artists"]["items"][0]["images"][0]["url"]
		artist_id = artist_api_response["artists"]["items"][0]["id"]

		album_api_response = HTTParty.get("https://api.spotify.com/v1/artists/#{artist_id}/albums")
		@album_image_0 = album_api_response["items"][0]["images"][0]["url"]
		@album_id_0 =  album_api_response["items"][0]["id"]
		@album_image_1 = album_api_response["items"][1]["images"][0]["url"]
		@album_id_1 =  album_api_response["items"][1]["id"]
		@album_image_2 = album_api_response["items"][2]["images"][0]["url"]
		@album_id_2 =  album_api_response["items"][2]["id"]

		last_fm_artist = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist=#{query}&api_key=0689c53570fb3e20176681c7b9d7aa30")
		@last_fm_artist_bio = last_fm_artist["lfm"]["artist"]["bio"]["summary"]
	end
end





