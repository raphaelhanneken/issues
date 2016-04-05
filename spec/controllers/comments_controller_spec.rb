# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  content    :text
#  user_id    :integer
#  report_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user)   { FactoryGirl.create(:user) }
  let(:report) { FactoryGirl.create(:report) }

  describe 'POST #create' do
    context 'as signed in user' do
      before(:each) do
        sign_in user
      end

      context 'with valid data' do
        let(:comment) { FactoryGirl.attributes_for :comment }

        before(:each) do
          post :create, { report_id: report.to_param, comment: comment }
        end

        it 'creates a new comment' do
          expect {
            post :create, { report_id: report.to_param, comment: comment }
          }.to change(Comment, :count).by(1)
        end

        it 'creates and persists a new instance of comment' do
          expect(assigns(:comment)).to be_a(Comment)
          expect(assigns(:comment)).to be_persisted
        end

        it 'assigns the created comment to the requested report' do
          report.reload
          expect(report.comments).to include(Comment.last)
        end

        it 'assigns the created comment to the current user' do
          user.reload
          expect(user.comments).to include(Comment.last)
        end

        it 'assigns a success message' do
          expect(flash['success']).to eq 'Comment created.'
        end

        it 'redirects to the requested report' do
          expect(response).to redirect_to report_path(report)
        end
      end

      context 'with invalid data' do
        let(:comment) { FactoryGirl.attributes_for :comment, content: nil }

        before(:each) do
          post :create, { report_id: report.to_param, comment: comment }
        end

        it 'does not create a new comment' do
          expect(assigns(:comment)).to be_a(Comment)
          expect(assigns(:comment)).not_to be_persisted
        end

        it 'assigns an error message' do
          expect(flash['error']).to eq 'Error.'
        end

        it 'redirects to the requested report' do
          expect(response).to redirect_to report_path(report)
        end
      end
    end

    context 'as guest user' do
      let(:comment) { FactoryGirl.attributes_for(:comment) }

      it 'redirects to the sign in page' do
        post :create, { report_id: report.to_param, comment: comment }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
