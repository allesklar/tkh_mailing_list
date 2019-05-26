class ProfilesController < ApplicationController

  before_action :authenticate

  before_action :set_profile

  def show
  end

  def edit
  end

  def update
    if @profile.update_attributes(profile_params)
      if params[:profile][:portrait].present?
        render :crop  ## Render the view for cropping
      else
        Activity.create doer_id: current_user.id, message: "performed a profile edit. See #{view_context.link_to 'public profile', member_path(@profile)}."
        redirect_to profile_path, notice: "<strong><span class=\"glyphicon glyphicon-ok-sign\"></span>&nbsp;&nbsp;Success!</strong> Your profile was updated."
      end
    else
      render action: "edit", warning: "<strong>Attention!</strong> A problem occurred while trying to update your profile. Plese try again."
    end
  end

  def history
    @activities = doer.activities.by_recent
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_profile
    @profile = Profile.find(current_user)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def profile_params
    params.require(:profile).permit :email, :first_name, :last_name, :other_name, :teacher_status, :portrait, :website_url, :facebook_url, :twitter_handle, :google_plus_url, :allow_newsletter, :allow_daily_digests, :crop_x, :crop_y, :crop_w, :crop_h
  end

end
