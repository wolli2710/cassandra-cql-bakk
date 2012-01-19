class FollowersController < ApplicationController

  def follow
    Follower.follow_user params[:uid], params[:follow]
    redirect_to users_path
  end

end
