class DetailsController < ApplicationController

  before_filter :authenticate
  before_filter :authenticate_with_admin

  def show
    @detail = Detail.find(params[:id])
    switch_to_admin_layout
  end

  def new
    @detail = Detail.new
    switch_to_admin_layout
  end

  def edit
    @detail = Detail.find(params[:id])
    switch_to_admin_layout
  end

  def create
    @detail = Detail.new(detail_params)
    # this is needed or has_secure_password won't validate the saving of a record
    @detail.password = 'temporary'
    @detail.password_confirmation = 'temporary'
    if @detail.save
      redirect_to @detail, notice: t('details.create.notice')
    else
      render action: "new", warning: t('details.create.warning'), layout: 'admin'
    end
  end

  def update
    @detail = Detail.find(params[:id])
    if @detail.update_attributes(detail_params)
      redirect_to @detail, notice: t('details.update.notice')
    else
      render action: "edit", warning: t('details.update.warning'), layout: 'admin'
    end
  end

  def destroy
    @detail = Detail.find(params[:id])
    if @detail.destroy
      redirect_to users_path, notice: t('details.destroy.notice')
    else
      redirect_to users_path, warning: t('details.destroy.warning')
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def detail_params
    params.require(:detail).permit(:admin, :teacher_status)
  end

end
