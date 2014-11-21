class ArtistController < ApplicationController

	def index

		# ////////// ARTIST'S SPOTIFY ID //////////
		query = params[:query]
		query = query.gsub(' ', '%20')
		artist_api_response = HTTParty.get("https://api.spotify.com/v1/search?q=#{query}&type=artist")
		@artist_image = artist_api_response["artists"]["items"][0]["images"][0]["url"]
		artist_id = artist_api_response["artists"]["items"][0]["id"]

		# ////////// ALBUM IMAGES AND PLAY BUTTON //////////
		# album_api_response = HTTParty.get("https://api.spotify.com/v1/artists/#{artist_id}/albums")
		# albums_sorted = album_api_response["items"].map do |album|
		# 	{ album_image: album["images"][0]["url"],
		# 		album_id: album["id"] }
		# end

		album_api_response = HTTParty.get("https://api.spotify.com/v1/artists/#{artist_id}/albums")
		@album_image_0 = album_api_response["items"][0]["images"][0]["url"]
		@album_id_0 =  album_api_response["items"][0]["id"]

		# albums_sorted_unique = albums_sorted.uniq do |album|
		# 	album[:album_image]
		# end

		# ////////// ARTIST BIO //////////
		last_fm_artist = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist=#{query}&api_key=0689c53570fb3e20176681c7b9d7aa30")
		@last_fm_artist_bio = last_fm_artist["lfm"]["artist"]["bio"]["summary"]


		# ////////// YOUTUBE //////////
		client = YouTubeIt::Client.new(:dev_key => "AIzaSyDnXMoqvyuUGI9kF5txoG5GKE5QXcp4rWk")
		artistnamejoined = query.gsub('%20','')
		youtube_api_response = client.videos_by(:query => "#{query}", :user => "#{artistnamejoined}"+"vevo", :page => 1, :per_page => 1)
		@youtube_player_url = youtube_api_response.videos[0].unique_id

		# ////////// MUZU //////////
		muzu_artist = HTTParty.get("http://api.muzu.tv/api/artist/details/?muzuid=NPhSxOzqs0&aname=#{query}")
		@muzu_video = muzu_artist["rss"]["channel"]["item"][0]["videoPlayerEmbedTag"]
		@array_of_muzu_videos = []
		muzu_artist["rss"]["channel"]["item"].each do |item|
			@array_of_muzu_videos << item["videoPlayerEmbedTag"]
		end



	end

end
