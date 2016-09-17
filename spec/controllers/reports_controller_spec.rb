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

require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  let!(:user) { FactoryGirl.create(:user) }

  describe 'GET #index' do
    let!(:report) { FactoryGirl.create(:report) }

    context 'as signed in user' do
      before(:each) do
        sign_in user
        get :index, {}
      end

      it 'returns http success' do
        expect(response).to have_http_status :success
      end

      it 'assigns @reports' do
        expect(assigns(:reports)).to match_array [report]
      end

      it 'renders the index template' do
        expect(response).to render_template 'index'
      end

      describe 'with filter' do
        let!(:report_01) { FactoryGirl.create(:report, reporter: user, assignee: nil) }
        let!(:report_02) { FactoryGirl.create(:report, assignee: user) }
        let!(:report_03) { FactoryGirl.create(:report, closed: true)}

        it 'assigns the correct subset for {}' do
          expect(assigns(:reports)).to contain_exactly report, report_01, report_02, report_03
        end

        it 'assigns the correct subset for :inbox' do
          get :index, { filter: 'inbox' }
          expect(assigns(:reports)).to contain_exactly report_01, report_02
        end

        it 'assigns the correct subset for :assigned_to_you' do
          get :index, { filter: 'assigned_to_you' }
          expect(assigns(:reports)).to contain_exactly report_02
        end

        it 'assigns the correct subset for :reported_by_you' do
          get :index, { filter: 'reported_by_you' }
          expect(assigns(:reports)).to contain_exactly report_01
        end

        it 'assigns the correct subset for :unassigned' do
          get :index, { filter: 'unassigned' }
          expect(assigns(:reports)).to contain_exactly report_01
        end

        it 'assigns the correct subset for :open' do
          get :index, { filter: 'open' }
          expect(assigns(:reports)).to contain_exactly report, report_01, report_02
        end

        it 'assigns the correct subset for :closed' do
          get :index, { filter: 'closed' }
          expect(assigns(:reports)).to contain_exactly report_03
        end
      end
    end

    context 'as guest user' do
      it 'redirects to the signin page' do
        get :index, {}
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #show' do
    let(:report) { FactoryGirl.create(:report) }

    context 'as signed in user' do
      before(:each) do
        sign_in user
        get :show, { id: report.to_param }
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'assigns the correct report' do
        expect(assigns(:report)).to eq report
      end

      it 'renders the show template' do
        expect(response).to render_template 'show'
      end
    end

    context 'as guest user' do
      it 'redirects to the signin page' do
        get :show, { id: report.to_param }
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe 'GET #new' do
    context 'as signed in user' do
      before(:each) do
        sign_in user
        xhr :get, :new
      end

      it 'returns http success' do
        expect(response).to have_http_status :success
      end

      it 'assigns a new report' do
        expect(assigns(:report)).to be_a_new Report
      end

      it 'renders the new template' do
        expect(response).to render_template 'new'
      end
    end

    context 'as guest user' do
      it 'redirects to the signin page' do
        get :new
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe 'GET #edit' do
    context 'as signed in user' do
      before(:each) do
        sign_in user
      end

      describe 'who reported the requested report' do
        let(:report) { FactoryGirl.create(:report, reporter: user) }

        before(:each) do
          get :edit, { id: report.to_param }
        end

        it 'returns http success' do
          expect(response).to have_http_status :success
        end

        it 'assigns the correct report' do
          expect(assigns(:report)).to eq report
        end

        it 'renders the edit template' do
          expect(response).to render_template 'edit'
        end
      end

      describe 'who is assigned to the requested report' do
        let(:report) { FactoryGirl.create(:report, assignee: user) }

        before(:each) do
          get :edit, { id: report }
        end

        it 'assigns an error message' do
          expect(flash[:error]).to eq 'Permission denied.'
        end

        it 'redirects to the root path' do
          expect(response).to redirect_to root_path
        end
      end

      describe 'who is neither assigned nor has reported the requested report' do
        let(:report) { FactoryGirl.create(:report) }

        before(:each) do
          get :edit, { id: report }
        end

        it 'assigns an error message' do
          expect(flash[:error]).to eq 'Permission denied.'
        end

        it 'redirects to the root path' do
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'as guest user' do
      it 'redirects to the signin page' do
        get :edit, { id: 1 }
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe 'POST #create' do
    context 'as signed in user' do
      before(:each) do
        sign_in user
      end

      describe 'with valid attributes' do
        let(:attrs) { FactoryGirl.build(:report).attributes }

        before(:each) do
          xhr :post, :create, { report: attrs }
        end

        it 'builds and persists a new report' do
          expect(assigns(:report)).to be_a Report
          expect(assigns(:report)).to be_persisted
        end

        it 'sets the reporter to the current user' do
          expect(assigns(:report).reporter).to eq user
        end

        it 'saves a new report' do
          expect {
            xhr :post, :create, { report: attrs }
          }.to change(Report, :count).by(1)
        end

        it 'renders the correct javascript' do
          expect(response.headers["Content-Type"]).to eq("text/javascript; charset=utf-8")
          expect(response.body).to include("window.location = '#{report_url(Report.last)}'")
        end

        it 'assigns a success flash message' do
          expect(flash[:success]).to eq 'Report created.'
        end
      end

      describe 'with invalid attributes' do
        let(:attrs) { FactoryGirl.attributes_for(:report, title: '  ') }

        before(:each) do
          xhr :post, :create, { report: attrs }
        end

        it 'builds a new report without persisting it' do
          expect(assigns(:report)).to be_a Report
          expect(assigns(:report)).not_to be_persisted
        end

        it 'does not save a new report' do
          expect {
            xhr :post, :create, { report: attrs }
          }.not_to change(Report, :count)
        end

        it 'sets the reporter to the current user' do
          expect(assigns(:report).reporter).to eq user
        end

        it 'renders the new template' do
          expect(response).to render_template 'new'
        end

        it 'generates error messages' do
          expect(assigns(:report).errors.any?).to be_truthy
        end
      end
    end

    context 'as guest user' do
      let(:attrs) { FactoryGirl.attributes_for(:report) }

      it 'does not save a new report' do
        expect {
          post :create, { report: attrs }
        }.not_to change(Report, :count)
      end

      it 'redirects to the signin page' do
        post :create, { report: attrs }
        expect(response).to redirect_to new_user_session_url
      end

      it 'responds with http status 401 via xhr' do
        xhr :post, :create, { report: attrs }
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'PUT #update' do
    context 'as signed in user' do
      before(:each) do
        sign_in user
      end

      describe 'who reported the requested report' do
        let(:report) { FactoryGirl.create(:report, reporter: user) }

        describe 'with valid attributes' do
          let(:attrs) { FactoryGirl.attributes_for(:report) }

          before(:each) do
            put :update, { id: report.to_param, report: attrs }
          end

          it 'assigns the requested report to @report' do
            expect(assigns(:report)).to eq report
          end

          it 'updates the requested report' do
            report.reload
            expect(report.title).to eq attrs[:title]
          end

          it 'redirects to the updated report' do
            expect(response).to redirect_to report_url(report)
          end

          it 'assigns a success flash message' do
            expect(flash[:success]).to eq 'Report updated.'
          end

          it 'does not generate any error messages' do
            expect(assigns(:report).errors.any?).to be_falsey
          end
        end

        describe 'with invalid attributes' do
          let(:attrs) { FactoryGirl.attributes_for(:report, title: '   ') }

          before(:each) do
            put :update, { id: report.to_param, report: attrs }
          end

          it 'does not update the requested report' do
            report.reload
            expect(report.title).not_to eq attrs['title']
          end

          it 'assigns the requested report to @report' do
            expect(assigns(:report)).to eq report
          end

          it 'renders the :edit template' do
            expect(response).to render_template :edit
          end

          it 'generates error messages' do
            expect(assigns(:report).errors.any?).to be_truthy
          end
        end
      end

      describe 'who is assigned to the requested report' do
        let(:report) { FactoryGirl.create(:report, assignee: user) }
        let(:attrs)  { FactoryGirl.attributes_for(:report) }

        before(:each) do
          put :update, { id: report.to_param, report: attrs }
        end

        it 'does not update the requested report' do
          report.reload
          expect(report.title).not_to eq attrs[:title]
        end

        it 'assigns an error message' do
          expect(flash[:error]).to eq 'Permission denied.'
        end

        it 'redirects to the root path' do
          expect(response).to redirect_to root_path
        end
      end

      describe 'who is neither assigned nor has reported the requested report' do
        let(:attrs)  { FactoryGirl.attributes_for(:report) }
        let(:report) { FactoryGirl.create(:report) }

        before(:each) do
          put :update, { id: report.to_param, report: attrs }
        end

        it 'does not update the requested report' do
          report.reload
          expect(report.title).not_to eq attrs[:title]
        end

        it 'assigns an error message' do
          expect(flash[:error]).to eq 'Permission denied.'
        end

        it 'redirects to the root path' do
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'as guest user' do
      let(:report) { FactoryGirl.create(:report) }
      let(:attrs)  { FactoryGirl.attributes_for(:report) }

      it 'does not update the requested report' do
        put :update, { id: report.to_param, report: attrs }
        report.reload
        expect(report).not_to eq attrs
      end

      it 'redirects to the signin page' do
        put :update, { id: report.to_param, report: attrs }
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe 'PUT #assign_to_me' do
    context 'as signed in user' do
      before(:each) do
        sign_in user
      end

      describe 'for an unassigned report' do
        let(:report) { FactoryGirl.create(:report, assignee: nil) }

        before(:each) do
          put :assign_to_me, { id: report.to_param }
        end

        it 'assigns the requested report to @report' do
          expect(assigns(:report)).to eq report
        end

        it 'assigns a success flash message' do
          expect(flash[:success]).to eq 'Assigned to you.'
        end

        it 'updates the assignee' do
          report.reload
          expect(report.assignee).to eq user
        end
      end

      describe 'for an already assigned report' do
        let(:assignee) { FactoryGirl.create(:user) }
        let(:report)   { FactoryGirl.create(:report, assignee: assignee) }

        before(:each) do
          put :assign_to_me, { id: report.to_param }
        end

        it 'assigns the requested report to @report' do
          expect(assigns(:report)).to eq report
        end

        it 'keeps the already assigned user' do
          report.reload
          expect(report.assignee).to eq assignee
        end

        it 'displays a notification' do
          expect(flash[:notice]).to eq 'Already assigned.'
        end

        it 'redirects to the requested report' do
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'as guest user' do
      let(:report) { FactoryGirl.create(:report, assignee: nil) }

      before(:each) do
        put :assign_to_me, { id: report.to_param }
      end

      it 'keeps the already assigned user' do
        report.reload
        expect(report.assignee).to be_nil
      end

      it 'redirects to the signin page' do
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe 'PUT #close' do
    context 'as signed in user' do
      before(:each) do
        sign_in user
      end

      context 'who reported the requested report' do
        let(:report) { FactoryGirl.create(:report, reporter: user) }

        before(:each) do
          put :close, { id: report.to_param }
        end

        it 'assigns the requested report to @report' do
          expect(assigns(:report)).to eq report
        end

        it 'closes the requested report' do
          report.reload
          expect(report.closed).to be_truthy
        end

        it 'redirects to the requested report' do
          expect(response).to redirect_to report_url(report)
        end

        it 'assigns a success message' do
          expect(flash[:success]).to eq 'Report closed.'
        end
      end

      context 'who is assigned to the requested report' do
        let(:report) { FactoryGirl.create(:report, assignee: user) }

        before(:each) do
          put :close, { id: report.to_param }
        end

        it 'assigns the requested report to @report' do
          expect(assigns(:report)).to eq report
        end

        it 'closes the requested report' do
          report.reload
          expect(report.closed).to be_truthy
        end

        it 'redirects to the requested report' do
          expect(response).to redirect_to report_url(report)
        end

        it 'assigns a success message' do
          expect(flash[:success]).to eq 'Report closed.'
        end
      end

      context 'who is neither assigned nor has reported the requested report' do
        let(:report) { FactoryGirl.create(:report) }

        before(:each) do
          put :close, { id: report.to_param }
        end

        it 'assigns the requested report to @report' do
          expect(assigns(:report)).to eq report
        end

        it 'does not close the requested report' do
          report.reload
          expect(report.closed).to be_falsey
        end

        it 'redirects to the root url' do
          expect(response).to redirect_to root_url
        end

        it 'assigns an error message' do
          expect(flash[:error]).to eq 'Permission denied.'
        end
      end
    end

    context 'as guest user' do
      let(:report) { FactoryGirl.build_stubbed(:report) }

      it 'responds with http status 300 via xhr' do
        xhr :put, :close, { id: report.to_param }
        expect(response).to have_http_status :unauthorized
      end

      it 'redirects to the signin page' do
        put :close, { id: report.to_param }
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe 'PUT #open' do
    context 'as signed in user' do
      before(:each) do
        sign_in user
      end

      context 'who reported the requested report' do
        let(:report) { FactoryGirl.create(:report, reporter: user, closed: true) }

        before(:each) do
          put :open, { id: report.to_param }
        end

        it 'assigns the requested report to @report' do
          expect(assigns(:report)).to eq report
        end

        it 'opens the requested report' do
          report.reload
          expect(report.closed).to be_falsey
        end

        it 'redirects to the requested report' do
          expect(response).to redirect_to report_url(report)
        end

        it 'assigns a success message' do
          expect(flash[:success]).to eq 'Report opened.'
        end
      end

      context 'who is assigned to the requested report' do
        let(:report) { FactoryGirl.create(:report, assignee: user, closed: true) }

        before(:each) do
          put :open, { id: report.to_param }
        end

        it 'assigns the requested report to @report' do
          expect(assigns(:report)).to eq report
        end

        it 'opens the requested report' do
          report.reload
          expect(report.closed).to be_falsey
        end

        it 'redirects to the requested report' do
          expect(response).to redirect_to report_url(report)
        end

        it 'assigns a success message' do
          expect(flash[:success]).to eq 'Report opened.'
        end
      end

      context 'who is neither assigned nor has reported the requested report' do
        let(:report) { FactoryGirl.create(:report, closed: true) }

        before(:each) do
          put :open, { id: report.to_param }
        end

        it 'assigns the requested report to @report' do
          expect(assigns(:report)).to eq report
        end

        it 'does not open the requested report' do
          report.reload
          expect(report.closed).to be_truthy
        end

        it 'redirects to the root url' do
          expect(response).to redirect_to root_url
        end

        it 'assigns an error message' do
          expect(flash[:error]).to eq 'Permission denied.'
        end
      end
    end

    context 'as guest user' do
      let(:report) { FactoryGirl.build_stubbed(:report) }

      it 'responds with http status 300 via xhr' do
        xhr :put, :open, { id: report.to_param }
        expect(response).to have_http_status :unauthorized
      end

      it 'redirects to the signin page' do
        put :open, { id: report.to_param }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET #edit_assignee' do
    let!(:new_assignee) { FactoryGirl.create(:user) }

    context 'as signed in user' do
      before(:each) do
        sign_in user
      end

      context 'who is the reporter' do
        let(:report) { FactoryGirl.create(:report, reporter: user) }

        before(:each) do
          xhr :get, :edit_assignee, { id: report.to_param }
        end

        it 'returns http status 200' do
          expect(response).to have_http_status :success
        end

        it 'assigns the requested report' do
          expect(assigns(:report)).to eq report
        end

        it 'renders the edit_assignee template' do
          expect(response).to render_template 'edit_assignee'
        end
      end

      context 'who is the assignee' do
        let(:report) { FactoryGirl.create(:report, assignee: user) }

        before(:each) do
          xhr :get, :edit_assignee, { id: report.to_param }
        end

        it 'returns http status 200' do
          expect(response).to have_http_status :success
        end

        it 'assigns the requested report' do
          expect(assigns(:report)).to eq report
        end

        it 'renders the edit_assignee template' do
          expect(response).to render_template 'edit_assignee'
        end
      end

      context 'who is neither the assignee nor the reporter' do
        let(:report) { FactoryGirl.create(:report) }

        before(:each) do
          xhr :get, :edit_assignee, { id: report.to_param }
        end

        it 'redirects to the root path' do
          expect(response).to redirect_to root_path
        end

        it 'assigns an error message' do
          expect(flash[:error]).to eq 'Permission denied.'
        end
      end
    end

    context 'as guest user' do
      let(:report) { FactoryGirl.build_stubbed(:report) }

      it 'responds with http status 300 via xhr' do
        xhr :get, :edit_assignee, { id: report.to_param }
        expect(response).to have_http_status :unauthorized
      end

      it 'redirects to the sign in path' do
        get :edit_assignee, { id: report.to_param }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PUT #update_assignee' do
    let!(:new_assignee) { FactoryGirl.create(:user) }

    context 'as signed in user' do
      before(:each) do
        sign_in user
      end

      context 'who is the reporter' do
        let!(:report) { FactoryGirl.create(:report, reporter: user) }

        before(:each) do
          put :update_assignee, { id: report.to_param, report: { assignee_id: new_assignee.id } }
        end

        it 'assigns the requested report' do
          expect(assigns(:report)).to eq report
        end

        it 'updates the requested report' do
          report.reload
          expect(report.assignee).to eq new_assignee
        end

        it 'redirects to the requested report' do
          expect(response).to redirect_to report_path(report)
        end

        it 'assigns a success message' do
          expect(flash[:success]).to eq 'Assignee updated.'
        end
      end

      context 'who is the assignee' do
        let!(:report) { FactoryGirl.create(:report, assignee: user) }

        before(:each) do
          put :update_assignee, { id: report.to_param, report: { assignee_id: new_assignee.id } }
        end

        it 'assigns the requested report' do
          expect(assigns(:report)).to eq report
        end

        it 'updates the requested report' do
          report.reload
          expect(report.assignee).to eq new_assignee
        end

        it 'redirects to the requested report' do
          expect(response).to redirect_to report_path(report)
        end

        it 'assigns a success message' do
          expect(flash[:success]).to eq 'Assignee updated.'
        end
      end

      context 'who is neither the assignee nor the reporter' do
        let(:report) { FactoryGirl.create(:report) }

        before(:each) do
          put :update_assignee, { id: report.to_param, report: { assignee_id: new_assignee.id } }
        end

        it 'redirects to the root path' do
          expect(response).to redirect_to root_path
        end

        it 'does not update the assignee' do
          report.reload
          expect(report.assignee).not_to eq new_assignee
        end

        it 'assigns an error message' do
          expect(flash[:error]).to eq 'Permission denied.'
        end
      end
    end

    context 'as guest user' do
      let(:report) { FactoryGirl.build_stubbed(:report) }

      before(:each) do
        put :update_assignee, { id: report.to_param, report: { assignee_id: new_assignee.id } }
      end

      it 'redirects to the signin path' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #edit_labels' do
    context 'as signed in user' do
      context 'who reported the requested report' do
        let(:report) { FactoryGirl.create(:report, reporter: user) }

        before(:each) do
          sign_in user
          xhr :get, :edit_labels, { id: report.to_param }
        end

        it 'responds with http status success' do
          expect(response).to have_http_status :success
        end

        it 'assigns the requested report' do
          expect(assigns(:report)).to eq report
        end

        it 'assigns all labels' do
          expect(assigns(:labels)).to eq Label.all
        end

        it 'renders the edit_labels template' do
          expect(response).to render_template 'edit_labels'
        end
      end

      context 'who is assigned to the requested report' do
        let(:report) { FactoryGirl.create(:report, assignee: user) }

        before(:each) do
          sign_in user
          xhr :get, :edit_labels, { id: report.to_param }
        end

        it 'responds with http status success' do
          expect(response).to have_http_status :success
        end

        it 'assigns the requested report' do
          expect(assigns(:report)).to eq report
        end

        it 'assigns all labels' do
          expect(assigns(:labels)).to eq Label.all
        end

        it 'renders the edit_labels template' do
          expect(response).to render_template 'edit_labels'
        end
      end

      context 'who is neither assigned nor has reported the requested report' do
        let(:report) { FactoryGirl.create(:report) }

        before(:each) do
          sign_in user
          xhr :get, :edit_labels, { id: report.to_param }
        end

        it 'redirects to the root path' do
          expect(response).to redirect_to root_path
        end

        it 'displays an error message' do
          expect(flash['error']).to eq 'Permission denied.'
        end
      end
    end

    context 'as guest user' do
      it 'redirects to the sign in page' do
        get :edit_labels, { id: 1 }
        expect(response).to redirect_to new_user_session_path
      end

      it 'responds with http status 300 via xhr' do
        xhr :get, :edit_labels, { id: 1 }
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'PUT #add_label' do
    context 'as signed in user' do
      before(:each) do
        sign_in user
      end

      context 'who reported the requested report' do
        let!(:label) { FactoryGirl.create(:label) }
        let(:report) { FactoryGirl.create(:report, reporter: user) }

        before(:each) do
          xhr :put, :add_label, { id: report.to_param, label_id: label.to_param }
        end

        it 'assigns the requested report' do
          expect(assigns(:report)).to eq report
        end

        it 'assigns the requested label' do
          expect(assigns(:label)).to eq label
        end

        it 'adds the requested label to the requested report' do
          report.reload
          expect(report.labels).to include label
        end

        it 'assigns a success message' do
          expect(flash['success']).to eq 'Label added.'
        end

        it 'renders the add_label template' do
          expect(response).to render_template 'add_label'
        end
      end

      context 'who is assigned to the requested report' do
        let!(:label) { FactoryGirl.create(:label) }
        let(:report) { FactoryGirl.create(:report, assignee: user) }

        before(:each) do
          xhr :put, :add_label, { id: report.to_param, label_id: label.to_param }
        end

        it 'assigns the requested report' do
          expect(assigns(:report)).to eq report
        end

        it 'assigns the requested label' do
          expect(assigns(:label)).to eq label
        end

        it 'adds the requested label to the requested report' do
          report.reload
          expect(report.labels).to include label
        end

        it 'assigns a success message' do
          expect(flash['success']).to eq 'Label added.'
        end

        it 'renders the add_label template' do
          expect(response).to render_template 'add_label'
        end
      end

      context 'who is neither assigned nor has reported the requested report' do
        let!(:label) { FactoryGirl.create(:label) }
        let(:report) { FactoryGirl.create(:report) }

        before(:each) do
          xhr :put, :add_label, { id: report.to_param, label_id: label.to_param }
        end

        it 'assigns a flash message' do
          expect(flash['error']).to eq 'Permission denied.'
        end

        it 'does not add the requested label to the requested report' do
          report.reload
          expect(report.labels).not_to include label
        end
      end
    end

    context 'as guest user' do
      it 'redirects to the sign in page' do
        put :add_label, { id: 1, label_id: 2 }
        expect(response).to redirect_to new_user_session_path
      end

      it 'return http status 300' do
        xhr :put, :add_label, { id: 1, label_id: 2 }
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'PUT #remove_label' do
    context 'as signed in user' do
      before(:each) do
        sign_in user
      end

      context 'who reported the requested report' do
        let!(:label) { FactoryGirl.create(:label) }
        let(:report) { FactoryGirl.create(:report, reporter: user, labels: [label]) }

        before(:each) do
          xhr :put, :remove_label, { id: report.to_param, label_id: label.to_param }
        end

        it 'assigns the requested report' do
          expect(assigns(:report)).to eq report
        end

        it 'assigns the requested label' do
          expect(assigns(:label)).to eq label
        end

        it 'removes the requested label from the requested report' do
          report.reload
          expect(report.labels).not_to include label
        end

        it 'assigns a success message' do
          expect(flash['success']).to eq 'Label removed.'
        end

        it 'renders the remove_label template' do
          expect(response).to render_template 'remove_label'
        end
      end

      context 'who is assigned to the requested report' do
        let!(:label) { FactoryGirl.create(:label) }
        let(:report) { FactoryGirl.create(:report, assignee: user, labels: [label]) }

        before(:each) do
          xhr :put, :remove_label, { id: report.to_param, label_id: label.to_param }
        end

        it 'assigns the requested report' do
          expect(assigns(:report)).to eq report
        end

        it 'assigns the requested label' do
          expect(assigns(:label)).to eq label
        end

        it 'removes the requested label from the requested report' do
          report.reload
          expect(report.labels).not_to include label
        end

        it 'assigns a success message' do
          expect(flash['success']).to eq 'Label removed.'
        end

        it 'renders the remove_label template' do
          expect(response).to render_template 'remove_label'
        end
      end

      context 'who is neither assigned nor has reported to requested report' do
        let!(:label) { FactoryGirl.create(:label) }
        let(:report) { FactoryGirl.create(:report, labels: [label]) }

        before(:each) do
          xhr :put, :remove_label, { id: report.to_param, label_id: label.to_param }
        end

        it 'assigns a flash message' do
          expect(flash['error']).to eq 'Permission denied.'
        end

        it 'does not add the requested label to the requested report' do
          report.reload
          expect(report.labels).to include label
        end
      end
    end

    context 'as guest user' do
      it 'redirects to the sign in page' do
        put :remove_label, { id: 1, label_id: 2 }
        expect(response).to redirect_to new_user_session_path
      end

      it 'responds with http status 300 via xhr' do
        xhr :put, :remove_label, { id: 1, label_id: 2 }
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
