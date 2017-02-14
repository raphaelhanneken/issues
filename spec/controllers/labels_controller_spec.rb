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

require 'rails_helper'

RSpec.describe LabelsController, type: :controller do
  let!(:user) { FactoryGirl.create(:user) }

  describe 'GET #show' do
    let(:label) { FactoryGirl.create(:label) }

    context 'as signed in user' do
      before(:each) do
        sign_in user
        get :show, id: label.to_param
      end

      it 'responds with https status success' do
        expect(response).to have_http_status :success
      end

      it 'assigns the requested label' do
        expect(assigns(:label)).to eq label
      end

      it 'renders the show template' do
        expect(response).to render_template 'show'
      end
    end

    context 'as guest user' do
      it 'redirects to the sign in page' do
        get :show, id: 3
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #new' do
    let!(:report) { FactoryGirl.create(:report) }

    context 'as signed in user' do
      before(:each) do
        sign_in user
        xhr :get, :new, report_id: report.to_param
      end

      it 'responds with http status success' do
        expect(response).to render_template 'new'
      end

      it 'assigns a new Label' do
        expect(assigns(:label)).to be_a_new(Label)
      end

      it 'renders the new template' do
        expect(response).to render_template 'new'
      end
    end

    context 'as guest user' do
      it 'redirects to the sign in page' do
        get :new, report_id: report.to_param
        expect(response).to redirect_to new_user_session_path
      end

      it 'responds with http status 300 via xhr' do
        xhr :get, :new, report_id: report.to_param
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'POST #create' do
    let!(:report) { FactoryGirl.create(:report) }

    context 'as signed in user' do
      before(:each) do
        sign_in user
      end

      context 'with valid data' do
        let!(:label) { FactoryGirl.attributes_for(:label) }

        before(:each) do
          xhr :post, :create, report_id: report.to_param, label: label
        end

        it 'creates a new label' do
          expect do
            xhr :post, :create, report_id: report.to_param, label: label
          end.to change(Label, :count).by(1)
        end

        it 'creates and persists a new instance of Label' do
          expect(assigns(:label)).to be_a(Label)
          expect(assigns(:label)).to be_persisted
        end

        it 'assigns the created label to the requested report' do
          report.reload
          expect(report.labels).to include(Label.last)
        end

        it 'assigns a success message' do
          expect(flash['success']).to eq 'New label added.'
        end

        it 'redirects to the requested report' do
          expect(response.headers['Content-Type']).to eq('text/javascript; charset=utf-8')
          expect(response.body).to include("window.location = '#{report_url(report)}'")
        end
      end

      context 'with invalid data' do
        let!(:label) { FactoryGirl.attributes_for(:label, title: nil) }

        before(:each) do
          xhr :post, :create, report_id: report.to_param, label: label
        end

        it 'creates a new instance of Label without persisting' do
          expect(assigns(:label)).to be_a Label
          expect(assigns(:label)).not_to be_persisted
        end

        it 'assigns an error message' do
          expect(assigns(:label).errors.any?).to be_truthy
        end

        it 'renders the new form' do
          expect(response).to render_template 'new'
        end
      end
    end

    context 'as guest user' do
      let(:label) { FactoryGirl.attributes_for(:label) }

      it 'redirects to the sign in page' do
        post :create, report_id: report.to_param, label: label
        expect(response).to redirect_to new_user_session_path
      end

      it 'responds with http status 300 via xhr' do
        xhr :post, :create, report_id: report.to_param, label: label
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:label) { FactoryGirl.create(:label) }
    let!(:labol) { FactoryGirl.create(:label) }

    context 'as signed in user' do
      let(:user)  { FactoryGirl.create(:user, admin: false) }
      let(:admin) { FactoryGirl.create(:user, admin: true) }

      context 'with admin privileges' do
        before(:each) do
          sign_in admin
          delete :destroy, id: label.to_param
        end

        it 'deletes the requested label' do
          expect do
            delete :destroy, id: labol.to_param
          end.to change(Label, :count).by(-1)
        end

        it 'redirects to the root path' do
          expect(response).to redirect_to root_path
        end

        it 'assigns a success message' do
          expect(flash['success']).to eq 'Label deleted.'
        end
      end

      context 'without admin privileges' do
        before(:each) do
          sign_in user
          delete :destroy, id: label.to_param
        end

        it 'does not delete the requested label' do
          expect do
            delete :destroy, id: labol.to_param
          end.not_to change(Label, :count)
        end

        it 'redirects to the root path' do
          expect(response).to redirect_to root_path
        end

        it 'assigns an error message' do
          expect(flash['error']).to eq 'Permission denied.'
        end
      end
    end

    context 'as guest user' do
      it 'redirects to the sign in page' do
        delete :destroy, id: label.to_param
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
