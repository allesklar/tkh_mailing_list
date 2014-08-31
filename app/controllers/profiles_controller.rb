class ProfilesController < ApplicationController

  before_filter :authenticate

  before_action :set_profile

  def show
  end

  def edit
  end

  def update
    if @profile.update_attributes(profile_params)
      redirect_to profile_path, notice: "<strong>Success!</strong> Your profile was updated.".html_safe
    else
      render action: "edit", warning: "<strong>Attention!</strong> A problem occurred while trying to update your profile. Plese try again".html_safe
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
    params.require(:profile).permit :email, :first_name, :last_name, :other_name, :teacher_status, :portrait, :website_url, :facebook_url, :twitter_handle, :google_plus_url, :allow_newsletter, :allow_daily_digests
  end

end
