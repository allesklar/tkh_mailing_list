class MembersController < ApplicationController

  before_filter :authenticate,            except: :show
  before_filter :authenticate_with_admin, except: :show

  before_action :set_member, only: [ :show, :edit, :update, :destroy ]

  def index
    @members = Member.by_recent.paginate(:page => params[:page], :per_page => 50)
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
      redirect_to @member, notice: t('members.create.notice')
    else
      render action: "new", warning: t('members.create.warning'), layout: 'admin'
    end
  end

  def update
    if @member.update_attributes(member_params)
      redirect_to @member, notice: t('members.update.notice')
    else
      render action: "edit", warning: t('members.update.warning'), layout: 'admin'
    end
  end

  def destroy
    if @member.destroy
      redirect_to users_path, notice: t('members.destroy.notice')
    else
      redirect_to users_path, warning: t('members.destroy.warning')
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_member
    @member = Member.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def member_params
    params.require(:member).permit( :email, :first_name, :last_name, :other_name, :teacher_status )
  end

end