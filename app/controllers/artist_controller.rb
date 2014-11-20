class ArtistController < ApplicationController

	def index
		query = params[:query]
		artist_api_response = HTTParty.get("https://api.spotify.com/v1/search?q=#{query}&type=artist")
    @artist_image = artist_api_response["artists"]["items"][0]["images"][0]["url"]
    artist_id = artist_api_response["artists"]["items"][0]["id"]

    album_api_response = HTTParty.get("https://api.spotify.com/v1/artists/#{artist_id}/albums")
    @album_image = album_api_response["items"][0]["images"][0]["url"]
    @album_id =  album_api_response["items"][0]["id"]

	end
end


# Testing API Responses
# artist_api_response = HTTParty.get("https://api.spotify.com/v1/search?q=Shakira&type=artist")
# artist_id = artist_api_response["artists"]["items"][0]["id"]
# album_api_response = HTTParty.get("https://api.spotify.com/v1/artists/0EmeFodog0BfCgMzAIvKQp/albums")
# tracks_api_response = HTTParty.get("https://api.spotify.com/v1/albums/6AuyoIozWlAwKtiBWpLgCk")
