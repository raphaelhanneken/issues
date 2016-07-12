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

class UsersController < ApplicationController
  include AjaxRedirect

  before_action :set_user, except: [:index]
  before_action :correct_user?, only: [:edit, :update, :edit_password, :update_password]
  before_action :correct_user_or_admin?, only: [:destroy]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/:id
  def show
    @activities = PublicActivity::Activity.where("owner_id = ? OR recipient_id = ?", @user, @user)
      .order(created_at: 'desc')
  end

  # GET /users/:id/edit
  def edit
  end

  # PATCH /users/:id
  # PUT   /users/:id
  def update
    if @user.update(permit_params)
      redirect_to @user, flash: { success: 'Profile updated.' }
    else
      render :edit
    end
  end

  # GET /users/:id/edit_password
  def edit_password
  end

  # PUT /users/:id/update_password
  def update_password
    if @user.update_with_password(permit_password_params)
      bypass_sign_in(@user)
      redirect_ajax_to @user, flash: { success: 'Password updated.' }
    else
      render :edit_password
    end
  end

  # DELETE /users/:id
  def destroy
    @user.destroy
    if current_user.admin?
      redirect_to users_path, flash: { success: 'Account deleted.' }
    else
      redirect_to new_user_session_path, flash: { success: 'Account deleted.'}
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def permit_params
      params.require(:user).permit(:email, :firstname, :lastname)
    end

    def permit_password_params
      params.require(:user).permit(:current_password, :password, :password_confirmation)
    end

    def correct_user?
      permission_denied unless @user == current_user
    end

    def correct_user_or_admin?
      correct_user? unless current_user.admin?
    end
end
