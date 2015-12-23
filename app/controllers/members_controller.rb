class MembersController < ApplicationController

  before_filter :authenticate,  except: [ :show, :unsubscribe_from_newsletter ]
  before_action -> { require_permission 'write_members'},
                                except: [ :show, :unsubscribe_from_newsletter ]
  before_action -> { require_permission 'write_roles'},
                                only: [ :add_role, :remove_role ]

  before_action :set_member, only: [ :show, :edit, :update, :destroy, :validate_email, :add_role, :remove_role ]

  def index
    @members = Member.by_recent.paginate(:page => params[:page], :per_page => 30)
    switch_to_admin_layout
  end

  def show
  end

  def new
    @member = Member.new
    switch_to_admin_layout
  end

  def edit
    switch_to_admin_layout
  end

  def create
    @member = Member.new(member_params)
    if @member.save
      redirect_to members_path, notice: t('members.create.notice')
    else
      render action: "new", warning: t('members.create.warning'), layout: 'admin'
    end
  end

  def update
    if @member.update_attributes(member_params)
      redirect_to members_path, notice: t('members.update.notice')
    else
      render action: "edit", warning: t('members.update.warning'), layout: 'admin'
    end
  end

  def destroy
    if @member.destroy
      redirect_to members_path, notice: t('members.destroy.notice')
    else
      redirect_to members_path, warning: t('members.destroy.warning')
    end
  end

  def search
    @members = Member.where("LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? OR LOWER(other_name) LIKE ? OR LOWER(email) LIKE ?", "%#{params[:query].downcase}%", "%#{params[:query].downcase}%", "%#{params[:query].downcase}%", "%#{params[:query].downcase}%").by_recent.limit(25)
  end

  def unsubscribe_from_newsletter
    @member = Member.find_by_auth_token(params[:id])
    @member.unsubscribe_from_newsletter!
    if Activity.create(   doer_id: @member.id,
                          message: "just <strong>unsubscribed</strong> from the <strong>enewsletter</strong>."   )
      redirect_to root_path, notice: "You have been successfully unsubscribed from our newsletter. Bye bye :-)"
    else
      redirect_to root_path, warning: "ATTENTION! There was a problem unsubscribing you from the newsletter. We do want to do our best to help you though. Please send an email to #{Setting.first.contact_email}"
    end
  end

  def validate_email
    @member.email_validated = true
    @member.save
    redirect_to members_path, notice: "Successfully validated the #{@member.email} email address."
  end

  def add_role
    role = Role.find(params[:role_id])
    @member.roles << role
    redirect_to members_path, notice: "The '#{role.name}' role has been added to #{@member.name}"
  end

  def remove_role
    role = Role.find(params[:role_id])
    @member.roles.delete role
    redirect_to members_path, notice: "The '#{role.name}' role has been removed from #{@member.name}"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_member
    @member = Member.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def member_params
    params.require(:member).permit :email, :first_name, :last_name, :other_name, :teacher_status, :portrait, :website_url, :facebook_url, :twitter_handle, :google_plus_url, :allow_newsletter, :allow_daily_digests
  end

end
