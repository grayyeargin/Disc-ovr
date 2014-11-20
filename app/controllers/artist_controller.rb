class ArtistController < ApplicationController

	def index
		query = params[:query]

		@api_response = HTTParty.get("https://api.spotify.com/v1/search?q=#{query}&type=artist&r=json")

	end
end
