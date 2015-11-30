class PowersController < ApplicationController

  before_filter :authenticate,            except: [ :show, :unsubscribe_from_newsletter ]
  before_filter :authenticate_with_admin, except: [ :show, :unsubscribe_from_newsletter ]
  # TODO change permission system

  def index
    @members = Member.by_recent.paginate(:page => params[:page], :per_page => 30)
    switch_to_admin_layout
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  # def member_params
  #   params.require(:member).permit :email, :first_name, :last_name, :other_name, :teacher_status, :portrait, :website_url, :facebook_url, :twitter_handle, :google_plus_url, :allow_newsletter, :allow_daily_digests
  # end

end
