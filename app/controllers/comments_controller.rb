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

class CommentsController < ApplicationController
  # POST /reports/:report_id/comments
  def create
    @comment = current_user.comments.build(permit_params)
    if @comment.save
      @comment.report.create_activity action: 'comment', owner: current_user, params: { content: @comment.content }
      flash[:success] = 'Comment created.'
    else
      flash[:error] = 'Error.'
    end
    redirect_to @comment.report
  end

  private

  def permit_params
    params.require(:comment).permit(:content).merge(report_id: params[:report_id])
  end
end
