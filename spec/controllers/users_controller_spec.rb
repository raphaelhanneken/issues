# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  firstname              :string           not null
#  lastname               :string           not null
#  admin                  :boolean          default(FALSE)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:session_user) { FactoryGirl.create(:user) }

  describe 'GET #index' do
    context 'as signed in user' do
      let(:user) { FactoryGirl.create(:user) }

      before(:each) do
        sign_in session_user
        get :index
      end

      it 'responds with http success' do
        expect(response).to have_http_status(:success)
      end

      it 'assigns @users' do
        expect(assigns(:users)).to eq([session_user, user])
      end

      it 'renders the index template' do
        expect(response).to render_template('index')
      end
    end

    context 'as guest user' do
      it 'redirects to the sign in page' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #show' do
    let(:user) { FactoryGirl.create(:user) }

    context 'as signed in user' do
      before(:each) do
        sign_in session_user
        get :show, { id: user.to_param }
      end

      it 'responds with http success' do
        expect(response).to have_http_status(:success)
      end

      it 'assigns the requested user' do
        expect(assigns(:user)).to eq(user)
      end

      it 'renders the show template' do
        expect(response).to render_template('show')
      end
    end

    context 'as guest user' do
      it 'redirects to the sign in page' do
        get :show, { id: user.to_param }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET #edit' do
    let(:user) { FactoryGirl.create(:user) }

    context 'as signed in user' do
      before(:each) do
        sign_in session_user
      end

      describe 'for the current_users profile' do
        before(:each) do
          get :edit, { id: session_user.to_param }
        end

        it 'responds with http success' do
          expect(response).to have_http_status(:success)
        end

        it 'assigns the requested user to @user' do
          expect(assigns(:user)).to eq(session_user)
        end

        it 'renders the edit template' do
          expect(response).to render_template('edit')
        end
      end

      describe 'for another users profile' do
        before(:each) do
          get :edit, { id: user.to_param }
        end

        it 'redirects to the root path' do
          expect(response).to redirect_to(root_path)
        end

        it 'displays a flash message' do
          expect(flash[:error]).to eq('Permission denied.')
        end
      end
    end

    context 'as guest user' do
      it 'redirects to the sign in page' do
        get :edit, { id: user.to_param }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'PUT #update' do
    let(:user) { FactoryGirl.create(:user) }

    context 'as signed in user' do
      before(:each) do
        sign_in session_user
      end

      describe 'for the current_users profile' do
        context 'with valid params' do
          let(:valid_update_params) { FactoryGirl.attributes_for(:user) }

          before(:each) do
            put :update, { id: session_user.to_param, user: valid_update_params }
          end

          it 'assigns the requested user to @user' do
            expect(assigns(:user)).to eq(session_user)
          end

          it 'assigns a success message' do
            expect(flash[:success]).to eq('Profile updated.')
          end

          it 'updates the requested user' do
            session_user.reload
            expect(session_user.firstname).to eq(valid_update_params[:firstname])
          end

          it 'redirects to the updated user' do
            expect(response).to redirect_to(session_user)
          end
        end

        context 'with invalid params' do
          let(:invalid_update_params) { FactoryGirl.attributes_for(:user, firstname: nil) }

          before(:each) do
            put :update, { id: session_user.to_param, user: invalid_update_params }
          end

          it 'does not update the requested user' do
            session_user.reload
            expect(session_user.firstname).not_to be_nil
          end

          it 'assigns the requested user to @user' do
            expect(assigns(:user)).to eq(session_user)
          end

          it 'renders the edit template' do
            expect(response).to render_template('edit')
          end
        end
      end

      describe 'for another users profile' do
        let(:params) { FactoryGirl.attributes_for(:user) }

        before(:each) do
          put :update, { id: user.to_param, user: params }
        end

        it 'does not update the requested user' do
          session_user.reload
          expect(session_user.attributes).not_to eq(params)
        end

        it 'redirects to the root_path' do
          expect(response).to redirect_to(root_path)
        end

        it 'assigns an error message' do
          expect(flash[:error]).to eq('Permission denied.')
        end
      end
    end

    context 'as guest user' do
      let(:valid_update_params) { FactoryGirl.attributes_for(:user) }

      it 'does not update the requested user' do
        session_user.reload
        expect(session_user.attributes).not_to eq(valid_update_params)
      end

      it 'redirects to the sign in page' do
        put :update, { id: user.to_param, user: valid_update_params }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:admin_user) { FactoryGirl.create(:user, admin: true) }
    let!(:user)       { FactoryGirl.create(:user) }

    context 'as signed in user' do
      describe 'deleting the current_users profile' do
        before(:each) do
          sign_in session_user
        end

        it 'deletes the requested user' do
          expect {
            delete :destroy, { id: session_user.to_param }
          }.to change(User, :count).by(-1)
        end

        it 'redirects to the signin page' do
          delete :destroy, { id: session_user.to_param }
          expect(response).to redirect_to(new_user_session_path)
        end

        it 'assigns a success message' do
          delete :destroy, { id: session_user.to_param }
          expect(flash[:success]).to eq('Account deleted.')
        end
      end

      describe 'deleting another users profile' do
        context 'with admin privileges' do
          before(:each) do
            sign_in admin_user
          end

          it 'deletes the requested user' do
            expect {
              delete :destroy, { id: user.to_param }
            }.to change(User, :count).by(-1)
          end

          it 'redirects to the users path' do
            delete :destroy, { id: user.to_param }
            expect(response).to redirect_to(users_path)
          end

          it 'assigns a success message' do
            delete :destroy, { id: user.to_param }
            expect(flash[:success]).to eq('Account deleted.')
          end
        end

        context 'without admin privileges' do
          before(:each) do
            sign_in session_user
          end

          it 'does not delete the requested user' do
            expect {
              delete :destroy, { id: user.to_param }
            }.not_to change(User, :count)
          end

          it 'redirects to the root path' do
            delete :destroy, { id: user.to_param }
            expect(response).to redirect_to(root_path)
          end

          it 'assigns an error message' do
            delete :destroy, { id: user.to_param }
            expect(flash[:error]).to eq('Permission denied.')
          end
        end
      end
    end

    context 'as guest user' do
      it 'does not delete the requested user' do
        expect {
          delete :destroy, { id: user.to_param }
        }.not_to change(User, :count)
      end

      it 'redirects to the sign in page' do
        delete :destroy, { id: user.to_param }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET #edit_password' do
    let(:user) { FactoryGirl.create(:user) }

    context 'as signed in user' do
      describe 'for the current_user' do
        before(:each) do
          sign_in session_user
          xhr :get, :edit_password, { id: session_user.to_param }
        end

        it 'responds with http success' do
          expect(response).to have_http_status(:success)
        end

        it 'assigns the requested user' do
          expect(assigns(:user)).to eq(session_user)
        end

        it 'renders the edit_password template' do
          expect(response).to render_template('edit_password')
        end
      end

      describe 'for other users' do
        before(:each) do
          sign_in session_user
          xhr :get, :edit_password, { id: user.to_param }
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
      it 'responds with http status 401 via XHR' do
        xhr :get, :edit_password, { id: user.to_param }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'redirects to the sign in page via get' do
        get :edit_password, { id: user.to_param }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PUT #update_password' do
    let(:user) { FactoryGirl.create(:user) }

    context 'as signed in user' do
      before(:each) do
        sign_in session_user
      end

      describe 'for the current user' do
        context 'with valid data' do
          before(:each) do
            xhr :put, :update_password, { id: session_user.to_param,
              user: { current_password: session_user.password, password: 'smarties', password_confirmation: 'smarties' } }
          end

          it 'assigns the requested user to @user' do
            expect(assigns(:user)).to eq(session_user)
          end

          it 'assigns a success message' do
            expect(flash[:success]).to eq('Password updated.')
          end

          it 'redirects to the updated user' do
            expect(response.headers["Content-Type"]).to eq("text/javascript; charset=utf-8")
            expect(response.body).to include("window.location = '#{user_url(session_user)}'")
          end
        end

        context 'with invalid data' do
          before(:each) do
            xhr :put, :update_password, { id: session_user.to_param,
              user: { current_password: 'test', password: 'smarties', password_confirmation: 'smarties' } }
          end

          it 'creates error messages' do
            expect(assigns(:user).errors.any?).to be_truthy
          end

          it 'assigns the requested user' do
            expect(assigns(:user)).to eq(session_user)
          end

          it 'renders the edit_password template' do
            expect(response).to render_template('edit_password')
          end
        end
      end

      describe 'for another user' do
        before(:each) do
          xhr :put, :update_password, { id: user.to_param,
            user: { current_password: user.password, password: 'smarties', password_confirmation: 'smarties'} }
        end

        it 'assigns an error message' do
          expect(flash[:error]).to eq('Permission denied.')
        end
      end
    end

    context 'as guest user' do
      it 'responds with http status 401 via xhr' do
        xhr :put, :update_password, { id: user.to_param,
          user: { current_password: user.password, password: 'smarties', password_confirmation: 'smarties'} }

        expect(response).to have_http_status(:unauthorized)
      end

      it 'redirects to the signin path via put' do
        put :update_password, { id: user.to_param,
          user: { current_password: user.password, password: 'smarties', password_confirmation: 'smarties'} }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
