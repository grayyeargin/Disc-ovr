class ArtistController < ApplicationController

	include ArtistHelper

	def index

		# ////////// ARTIST'S SPOTIFY ID & MAIN PHOTO & NAME //////////
		client_id_and_secret = Base64.strict_encode64("#{ENV["client_id"]}:#{ENV["client_secret"]}")
		spotify_auth = HTTParty.post("https://accounts.spotify.com/api/token",
    	:body => { :grant_type => "client_credentials"
    		},
    	:headers => { "Authorization" => "Basic #{client_id_and_secret}" })
		query = params[:query]
		query_url = query.gsub(' ', '%20')
		artist_api_response = HTTParty.get("https://api.spotify.com/v1/search?q=#{query_url}&type=artist",
			 :headers => {"Authorization" => "Bearer #{spotify_auth['access_token']}"})
		@artist_image = artist_api_response["artists"]["items"][0]["images"][0]["url"]
		artist_id = artist_api_response["artists"]["items"][0]["id"]
		@artist_name = artist_api_response["artists"]["items"][0]["name"]
		@artist_name_url = @artist_name.gsub(' ', '%20')

		# ////////// ALBUM IMAGES AND PLAY BUTTON //////////
		spotify_query = Spotifysearch.new(artist_id, spotify_auth)
		@albums_sorted_unique = spotify_query.grab_unique_albums


		# ////////// ARTIST BIO //////////
		last_fm_artist = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist=#{@artist_name_url}&api_key=0689c53570fb3e20176681c7b9d7aa30")
		@last_fm_artist_bio = last_fm_artist["lfm"]["artist"]["bio"]["summary"]


		# ////////// YOUTUBE //////////
		videos = Yt::Collections::Videos.new
		youtube_api_response_vevo = videos.where(q: "#{@artist_name} music", order: 'viewCount').first(3)
		youtube_videos = []

		if youtube_api_response_vevo.count >= 3
			youtube_api_response_vevo.each do |video|
				youtube_videos << video.id
			end
		else
			youtube_api_response_music = videos.where(q: "#{@artist_name} music", order: 'viewCount').first(3)
			youtube_api_response_music.each do |video|
				youtube_videos << video.id
			end
		end

		@video_0 = youtube_videos[0]
		@video_1 = youtube_videos[1]
		@video_2 = youtube_videos[2]

		# # ////////// TWITTER DATA //////////
		twitter_client = Twittersearch.new(query)
 			@twitter_results = twitter_client.twitter_query

 		# ////////// REDDIT DATA //////////
 		reddit_response = HTTParty.get("https://www.reddit.com/r/subreddit/search.json?q=#{@artist_name_url}%20music&limit=10&sort=hot", :headers => {"User-agent" => "Music Map API"})
 		@reddit_results = []
 		if reddit_response["data"]["children"] != nil
 			reddit_response["data"]["children"].each do |link|
 				@reddit_results << {title: link["data"]["title"], permalink: "http://www.reddit.com" + link["data"]["permalink"], thumbnailurl: link["data"]["thumbnail"], author: link["data"]["author"], created_utc: Time.at(link["data"]["created_utc"]), ups: link["data"]["ups"], num_comments: link["data"]["num_comments"]}
 			end
 		end

 	end
end
