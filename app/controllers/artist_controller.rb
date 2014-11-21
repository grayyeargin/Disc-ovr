class ArtistController < ApplicationController

	def index

		# ////////// ARTIST'S SPOTIFY ID //////////
		query = params[:query]
		query = query.gsub(' ', '%20')
		artist_api_response = HTTParty.get("https://api.spotify.com/v1/search?q=#{query}&type=artist")
		@artist_image = artist_api_response["artists"]["items"][0]["images"][0]["url"]
		artist_id = artist_api_response["artists"]["items"][0]["id"]

		# ////////// ALBUM IMAGES AND PLAY BUTTON //////////
		album_api_response = HTTParty.get("https://api.spotify.com/v1/artists/#{artist_id}/albums")
		albums_sorted = album_api_response["items"].map do |album|
			{ album_image: album["images"][0]["url"],
				album_id: album["id"] }
		end
		albums_sorted_unique = albums_sorted.uniq do |album|
			album[:album_image]
		end

		@album_image_0 = albums_sorted_unique[0][:album_image]
		@album_id_0 = albums_sorted_unique[0][:album_id]
		@album_image_1 = albums_sorted_unique[1][:album_image]
		@album_id_1 = albums_sorted_unique[1][:album_id]
		@album_image_2 = albums_sorted_unique[2][:album_image]
		@album_id_2 = albums_sorted_unique[2][:album_id]
		@album_image_3 = albums_sorted_unique[3][:album_image]
		@album_id_3 = albums_sorted_unique[3][:album_id]
		@album_image_4 = albums_sorted_unique[4][:album_image]
		@album_id_4 = albums_sorted_unique[4][:album_id]
		@album_image_5 = albums_sorted_unique[5][:album_image]
		@album_id_5 = albums_sorted_unique[5][:album_id]
		@album_image_6 = albums_sorted_unique[6][:album_image]
		@album_id_6 = albums_sorted_unique[6][:album_id]
		@album_image_7 = albums_sorted_unique[7][:album_image]
		@album_id_7 = albums_sorted_unique[7][:album_id]
		@album_image_8 = albums_sorted_unique[8][:album_image]
		@album_id_8 = albums_sorted_unique[8][:album_id]
		@album_image_9 = albums_sorted_unique[9][:album_image]
		@album_id_9 = albums_sorted_unique[9][:album_id]
		@album_image_10 = albums_sorted_unique[10][:album_image]
		@album_id_10 = albums_sorted_unique[10][:album_id]
		@album_image_11 = albums_sorted_unique[11][:album_image]
		@album_id_11 = albums_sorted_unique[11][:album_id]



		# ////////// ARTIST BIO //////////
		last_fm_artist = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist=#{query}&api_key=0689c53570fb3e20176681c7b9d7aa30")
		@last_fm_artist_bio = last_fm_artist["lfm"]["artist"]["bio"]["summary"]

	end
end







# album_image_0 = albums_sorted_unique[0][:album_image]
# album_id_0 = albums_sorted_unique[0][:album_id]




























