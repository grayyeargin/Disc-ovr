class LikesController < ApplicationController

  def create
    like = Like.create(like_params)

    respond_to do |format|
      format.json { render :json => { message: "successfully added" }}
    end
  end

  # create statment is a little long.  why not return desired params from a method?
  private

  def like_params
    {
      user_id: params[:user_id], image_url: params[:image_url],
      artist_name: params[:artist_name], artist_url: params[:artist_url]
    }
  end


end