# == Schema Information
#
# Table name: reports
#
#  id          :integer          not null, primary key
#  title       :string           not null
#  description :text             not null
#  project_id  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  reporter_id :integer
#  assignee_id :integer
#  closed      :boolean
#

class ReportsController < ApplicationController
  include AjaxRedirect

  before_action :set_report,    except: [:index, :new, :create]
  before_action :set_label,     only:   [:add_label, :remove_label]
  before_action :is_assigned?,  only:   [:assign_to_me]
  before_action :correct_user?, except: [:show, :index, :new, :create, :edit, :update, :assign_to_me]
  before_action :reporter?,     only:   [:edit, :update]

  # GET /reports
  # GET /reports/assigned_to_me
  # GET /reports/unassigned
  def index
    @reports = filter_reports.order(updated_at: 'desc').eager_load(:reporter)
  end

  # GET /reports/:id
  def show
    @comment    = current_user.comments.new
    @activities = PublicActivity::Activity.where(trackable: @report).order(created_at: 'desc')
  end

  # GET /reports/new
  def new
    @report = Report.new
  end

  # POST /reports
  def create
    @report = current_user.reported.build(report_params)
    if @report.save
      @report.create_activity action: 'create', owner: current_user
      redirect_ajax_to @report, flash: { success: 'Report created.' }
    else
      render :new
    end
  end

  # GET /reports/:id/edit
  def edit
  end

  # PATCH /reports/:id
  # PUT   /reports/:id
  def update
    if @report.update(report_params)
      @report.create_activity action: 'update', owner: current_user
      redirect_to @report, flash: { success: 'Report updated.' }
    else
      render :edit
    end
  end

  # PUT /assign_to_me
  def assign_to_me
    if @report.update(assignee: current_user)
      @report.create_activity action: 'update_assignee', owner: current_user
      redirect_to @report, flash: { success: 'Assigned to you.' }
    else
      redirect_to @report, flash: { error: 'Error.' }
    end
  end

  # GET /reports/:id/edit_assignee
  def edit_assignee
  end

  # PUT /reports/:id/update_assignee
  def update_assignee
    if @report.update(params.require(:report).permit(:assignee_id))
      @report.create_activity action: 'update_assignee', owner: current_user
      redirect_to @report, flash: { success: 'Assignee updated.' }
    else
      redirect_to @report, flash: { error: 'Error.' }
    end
  end

  # PUT /reports/:id/close
  def close
    if @report.update(closed: true)
      @report.create_activity action: 'closed', owner: current_user
      redirect_to @report, flash: { success: 'Report closed.' }
    else
      redirect_to @report, flash: { error: 'Error.' }
    end
  end

  # PUT /reports/:id/open
  def open
    if @report.update(closed: false)
      @report.create_activity action: 'reopened', owner: current_user
      redirect_to @report, flash: { success: 'Report opened.' }
    else
      redirect_to @report, flash: { error: 'Error.' }
    end
  end

  # GET /reports/:id/edit_labels
  def edit_labels
    @labels = Label.all
  end

  # PUT /reports/:id/remove_label/:label_id
  def remove_label
    @report.labels.delete(@label)
    @report.create_activity action: 'remove_label', owner: current_user, params: { title: @label.title, color: @label.color }
    flash.now[:success] = 'Label removed.'
  end

  # PUT /reports/:id/add_label/:label_id
  def add_label
    @report.labels.append(@label)
    @report.create_activity action: 'add_label', owner: current_user, params: { title: @label.title, color: @label.color }
    flash.now[:success] = 'Label added.'
  end

  private

    def report_params
      params.require(:report).permit(:title, :description, :project_id, :assignee_id)
    end

    def set_report
      @report = Report.find(params[:id])
    end

    def set_label
      @label = Label.find(params[:label_id])
    end

    def is_assigned?
      redirect_to root_path, flash: { notice: 'Already assigned.' } unless @report.assignee.nil?
    end

    def correct_user?
      redirect_to root_path, flash: { error: 'Permission denied.' } unless @report.assignee?(current_user) || @report.reporter?(current_user)
    end

    def reporter?
      redirect_to root_path, flash: { error: 'Permission denied.' } unless @report.reporter?(current_user)
    end

    def filter_reports
      case params[:filter]
        when 'inbox'           then Report.inbox(current_user)
        when 'assigned_to_you' then Report.assigned_to(current_user)
        when 'reported_by_you' then Report.reported_by(current_user)
        when 'unassigned'      then Report.unassigned
        when 'open'            then Report.open
        when 'closed'          then Report.closed
        else Report.all
      end
    end
end
