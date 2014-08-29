class ProfilesController < ApplicationController

  before_filter :authenticate

  before_action :set_profile, only: [ :show, :edit, :update ]

  def show
  end

  def edit
  end

  def update
    # if @member.update_attributes(member_params)
    #   redirect_to @member, notice: t('members.update.notice')
    # else
    #   render action: "edit", warning: t('members.update.warning'), layout: 'admin'
    # end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_profile
    @profile = Profile.find(current_user)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def profile_params
    params.require(:profile).permit( :first_name, :last_name, :other_name )
  end

end
