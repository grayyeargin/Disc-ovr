class ArtistController < ApplicationController

	include ArtistHelper

	def index
    # this action is pretty intense.  is there a way that you could potentially abstract
    # this logic out to a module or break it into methods?  I think it would be a good
    # exercise for you guys.

		# ////////// ARTIST'S SPOTIFY ID & MAIN PHOTO & NAME //////////
		query = params[:query]
		query = query.gsub(' ', '%20')
		artist_api_response = HTTParty.get("https://api.spotify.com/v1/search?q=#{query}&type=artist")
		@artist_image = artist_api_response["artists"]["items"][0]["images"][0]["url"]
		artist_id = artist_api_response["artists"]["items"][0]["id"]
		@artist_name = artist_api_response["artists"]["items"][0]["name"]

		# ////////// ALBUM IMAGES AND PLAY BUTTON //////////
		spotify_query = Spotifysearch.new(artist_id)
		@albums_sorted_unique = spotify_query.grab_unique_albums



		# ////////// ARTIST BIO //////////
		last_fm_artist = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist=#{query}&api_key=0689c53570fb3e20176681c7b9d7aa30")
		@last_fm_artist_bio = last_fm_artist["lfm"]["artist"]["bio"]["summary"]



		# ////////// YOUTUBE //////////
		client = YouTubeIt::Client.new(:dev_key => "AIzaSyDnXMoqvyuUGI9kF5txoG5GKE5QXcp4rWk")
		youtube_api_response_all = client.videos_by(:query => "#{query}", :page => 1, :per_page => 50)
		vevo_videos = []
		non_vevo_videos = []
		youtube_api_response_all.videos.each do |video|
			if video.author.name.include?("VEVO")
				vevo_videos << video.unique_id
			else
				non_vevo_videos << video.unique_id
			end
		end

		if vevo_videos[0] != nil
			@video_0 = vevo_videos[0]
		else
			@video_0 = non_vevo_videos[0]
		end
		if vevo_videos[1] != nil
			@video_1 = vevo_videos[1]
		else
			@video_1 = non_vevo_videos[1]
		end
		if vevo_videos[2] != nil
			@video_2 = vevo_videos[2]
		else
			@video_2 = non_vevo_videos[2]
		end

		# # ////////// TWITTER DATA //////////
		twitter_client = Twittersearch.new(query)
 			@twitter_results = twitter_client.twitter_query

 		# ////////// REDDIT DATA //////////
 		reddit_response = HTTParty.get("http://www.reddit.com/r/subreddit/search.json?q=#{query}&limit=10&sort=hot")
 		@reddit_results = []
 		if reddit_response["data"]["children"] != nil
 			reddit_response["data"]["children"].each do |link|
 				@reddit_results << {title: link["data"]["title"], permalink: "http://www.reddit.com" + link["data"]["permalink"], thumbnailurl: link["data"]["thumbnail"], author: link["data"]["author"], created_utc: Time.at(link["data"]["created_utc"]), ups: link["data"]["ups"], num_comments: link["data"]["num_comments"]}
 			end
 		end

 	end
end
