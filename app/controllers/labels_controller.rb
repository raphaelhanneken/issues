# == Schema Information
#
# Table name: labels
#
#  id         :integer          not null, primary key
#  title      :string
#  color      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class LabelsController < ApplicationController
  include AjaxRedirect

  before_action :set_report,     only: [:new, :create]
  before_action :set_label,      only: [:show, :destroy]
  before_action :requires_admin, only: [:destroy]

  # GET /labels/:id
  def show; end

  # GET /reports/:report_id/labels/new
  def new
    @label = @report.labels.new
  end

  # POST /reports/:report_id/labels
  def create
    @label = Label.new(permit_params)
    if @label.save
      @label.create_activity action: 'create', owner: current_user, params: { title: @label.title, color: @label.color }
      @report.labels << @label
      @report.create_activity action: 'add_label', owner: current_user, params: { title: @label.title, color: @label.color }
      redirect_ajax_to @report, flash: { success: 'New label added.' }
    else
      render :new
    end
  end

  # DELETE /labels/:id
  def destroy
    @label = Label.find(params[:id])
    if @label.destroy
      redirect_to root_path, flash: { success: 'Label deleted.' }
    else
      render :show
    end
  end

  private

  def permit_params
    params.require(:label).permit(:title, :color)
  end

  def set_label
    @label = Label.find(params[:id])
  end

  def set_report
    @report = Report.find(params[:report_id])
  end

  def correct_user
    permission_denied unless @report.is_reporter?(current_user) || @report.is_assignee?(current_user)
  end
end
