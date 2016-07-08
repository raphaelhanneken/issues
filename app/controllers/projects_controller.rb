# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  version    :string           default("")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProjectsController < ApplicationController
  before_action :set_project,    except: [:index, :new, :create]
  before_action :requires_admin, except: [:index, :show]

  # GET /projects
  def index
    @projects = Project.all
  end

  # GET /projects/:id
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # POST /projects
  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to @project, flash: { success: 'Project created.' }
    else
      render :new
    end
  end

  # GET /projects/:id/edit
  def edit
  end

  # PATCH /projects/:id
  # PUT   /projects/:id
  def update
    if @project.update(project_params)
      redirect_to @project, flash: { success: 'Project updated.' }
    else
      render :edit
    end
  end

  # DELETE /projects/:id
  def destroy
    @project.destroy
    redirect_to projects_url, flash: { success: 'Project deleted.' }
  end


  private

    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:name, :description, :version, :url, :owner_id)
    end

    def requires_admin
      permission_denied unless current_user.admin?
    end
end
