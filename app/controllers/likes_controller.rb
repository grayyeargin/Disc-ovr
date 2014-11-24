class LikesController < ApplicationController

  def create
    like = Like.create(user_id: params[:user_id], image_url: params[:image_url], artist_name: params[:artist_name], artist_url: params[:artist_url])

    respond_to do |format|
      format.json { render :json => { message: "successfully added" }}
    end
  end

end