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

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let!(:user)  { FactoryGirl.create(:user) }
  let!(:admin) { FactoryGirl.create(:user, admin: true) }

  describe 'GET #index' do
    context 'as signed in user' do
      let(:project) { FactoryGirl.create(:project) }

      before(:each) do
        sign_in user
        get :index, {}
      end

      it 'responds with status 200' do
        expect(response).to have_http_status(:success)
      end

      it 'assigns @projects' do
        expect(assigns(:projects)).to eq([project])
      end
      
      it 'renders the index template' do
        expect(response).to render_template('index')
      end
    end

    context 'as guest user' do
      it 'redirects to the sign in page' do
        get :index, {}
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET #show" do
    let(:project) { FactoryGirl.create(:project) }

    context 'as signed in user' do
      context 'with admin privileges' do
        before(:each) do
          sign_in user
          get :show, { id: project.to_param }
        end

        it 'responds with status 200' do
          expect(response).to have_http_status(:success)
        end

        it "assigns the requested project as @project" do
          expect(assigns(:project)).to eq(project)
        end
        
        it 'renders the show template' do
          expect(response).to render_template('show')
        end
      end
    end

    context 'as guest user' do
      it 'redirects to the sign in page' do
        get :show, { id: project.to_param }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET #new" do
    context 'as signed in user' do
      context 'with admin privileges' do
        before(:each) do
          sign_in admin
          get :new, {}
        end

        it 'responds with status 200' do
          expect(response).to have_http_status(:success)
        end

        it "assigns a new project as @project" do
          expect(assigns(:project)).to be_a_new(Project)
        end
        
        it 'renders the new template' do
          expect(response).to render_template('new')
        end
      end

      context 'without admin privileges' do
        before(:each) do
          sign_in user
          get :new
        end
        
        it 'redirects to the root path' do
          expect(response).to redirect_to(root_path)
        end
        
        it 'assigns an error message' do
          expect(flash[:error]).to eq('Permission denied.')
        end
      end
    end

    context 'as guest user' do
      it 'redirects to the sign in page' do
        get :new, {}
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET #edit" do
    let(:project) { FactoryGirl.create(:project) }

    context 'as signed in user' do
      context 'with admin privileges' do
        before(:each) do
          sign_in admin
          get :edit, { id: project.to_param }
        end

        it 'responds with http status 200' do
          expect(response).to have_http_status(:success)
        end

        it "assigns the requested project as @project" do
          expect(assigns(:project)).to eq(project)
        end
        
        it 'renders the edit template' do
          expect(response).to render_template('edit')
        end
      end
      
      context 'without admin privileges' do
        before(:each) do
          sign_in user
          get :edit, { id: project.to_param }
        end
        
        it 'redirects to the root path' do
          expect(response).to redirect_to(root_path)
        end
        
        it 'assigns an error message' do
          expect(flash[:error]).to eq('Permission denied.')
        end
      end
    end

    context 'as guest user' do
      it 'redirects to the sign in page' do
        get :edit, { id: project.to_param }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "POST #create" do
    context 'as signed in user' do
      context 'with admin privileges' do
        before(:each) do
          sign_in admin
        end

        context "posting valid params" do
          let(:valid_attr) { FactoryGirl.build(:project).attributes }

          it "creates a new Project" do
            expect {
              post :create, { project: valid_attr }
            }.to change(Project, :count).by(1)
          end

          it "assigns the new project to @project" do
            post :create, { project: valid_attr }
            expect(assigns(:project)).to be_a(Project)
            expect(assigns(:project)).to be_persisted
          end

          it "redirects to the created project" do
            post :create, { project: valid_attr }
            expect(response).to redirect_to(Project.last)
          end
        
          it 'assigns a success message' do
            post :create, { project: valid_attr }
            expect(flash[:success]).to eq('Project created.')
          end
        end

        context "posting invalid params" do
          let(:invalid_attr) { FactoryGirl.build(:project, name: nil).attributes }
          
          it 'does not create a new report' do
            expect {
              post :create, { project: invalid_attr }
            }.not_to change(Project, :count)
          end

          it "assigns a newly created but unsaved project to @project" do
            post :create, { project: invalid_attr }
            expect(assigns(:project)).to be_a_new(Project)
          end

          it "renders the 'new' template" do
            post :create, { project: invalid_attr }
            expect(response).to render_template("new")
          end
        
          it 'generates error messages' do
            post :create, { project: invalid_attr }
            expect(assigns(:project).errors.any?).to be_truthy
          end
        end
      end
      
      context 'without admin privileges' do
        let(:attrs) { FactoryGirl.build(:project).attributes }
        
        before(:each) do
          sign_in user
          post :create, { project: attrs }
        end
        
        it 'does not create a new project' do
          expect {
            post :create, { project: attrs }
          }.not_to change(Project, :count)
        end
        
        it 'redirects to the root path' do
          expect(response).to redirect_to(root_path)
        end
        
        it 'assigns an error message' do
          expect(flash[:error]).to eq('Permission denied.')
        end
      end
    end

    context 'as guest user' do
      let(:valid_attr) { FactoryGirl.build(:project).attributes }
        
      it 'does not create a new project' do
        expect {
          post :create, { project: valid_attr }
        }.not_to change(Project, :count)
      end

      it 'redirects to the sign in page' do
        post :create, { project: valid_attr }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "PUT #update" do
    let(:project) { FactoryGirl.create(:project) }

    context 'as signed in user' do
      context 'with admin privileges' do
        before(:each) do
          sign_in admin
        end

        context "with valid params" do
          let(:valid_update_attr) { FactoryGirl.build(:project).attributes }

          before(:each) do
            put :update, { id: project.to_param, project: valid_update_attr }
          end

          it "updates the requested project" do
            project.reload
            expect(project.name).to eq(valid_update_attr['name'])
          end

          it "assigns the requested project as @project" do
            expect(assigns(:project)).to eq(project)
          end

          it "redirects to the project" do
            expect(response).to redirect_to(project)
          end
        end

        context "with invalid params" do
          let(:invalid_update_attr) { FactoryGirl.build(:project, name: nil).attributes }

          before(:each) do
            put :update, { id: project.to_param, project: invalid_update_attr }
          end
          
          it 'does not update the requested project' do
            project.reload
            expect(project.name).not_to be_nil
          end

          it "assigns the project as @project" do
            expect(assigns(:project)).to eq(project)
          end

          it "re-renders the 'edit' template" do
            expect(response).to render_template("edit")
          end
        end
      end
      
      context 'without admin privileges' do
        let(:attrs) { FactoryGirl.build(:project).attributes }
        
        before(:each) do
          sign_in user
          put :update, { id: project.to_param, project: attrs }
        end
        
        it 'does not updated the requested report' do
          project.reload
          expect(project.name).not_to eq(attrs['name'])
        end
        
        it 'redirects to the root path' do
          expect(response).to redirect_to(root_path)
        end
        
        it 'assigns an error message' do
          expect(flash[:error]).to eq('Permission denied.')
        end
      end
    end

    context 'as guest user' do
      let(:valid_update_attr) { FactoryGirl.build(:project).attributes }
        
      it 'does not updated the requested report' do
        put :update, { id: project.to_param, project: valid_update_attr }
        project.reload
        expect(project.name).not_to eq(valid_update_attr['name'])
      end

      it 'redirects to the sign in page' do
        put :update, { id: project.to_param, project: valid_update_attr }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:project) { FactoryGirl.create(:project) }

    context 'as signed in user' do
      context 'with admin privileges' do
        before(:each) do
          sign_in admin
        end

        it 'destroys the requested project' do
          expect {
            delete :destroy, { id: project.to_param }
          }.to change(Project, :count).by(-1)
        end

        it 'redirects to the projects list' do
          delete :destroy, { id: project.to_param }
          expect(response).to redirect_to(projects_url)
        end
      end
      
      context 'without admin privileges' do
        before(:each) do
          sign_in user
          delete :destroy, { id: project.to_param }
        end

        it 'does not destroy the requested project' do
          expect {
            delete :destroy, { id: project.to_param }
          }.not_to change(Project, :count)
        end
        
        it 'redirects to the root path' do
          expect(response).to redirect_to(root_path)
        end
        
        it 'assigns an error message' do
          expect(flash[:error]).to eq('Permission denied.')
        end
      end
    end

    context 'as guest user' do
      it 'does not destroy the requested project' do
        expect {
          delete :destroy, { id: project.to_param }
        }.not_to change(Project, :count)
      end
      
      it 'redirects to the sign in page' do
        delete :destroy, { id: project.to_param }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end
end
