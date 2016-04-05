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

RSpec.describe Comment, type: :model do
  let(:comment) { FactoryGirl.build(:comment) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:report) }

  it 'has a valid factory' do
    expect(comment).to be_valid
  end

  it 'saves a valid instance' do
    expect {
      comment.save!
    }.to change(Comment, :count).by(1)
  end

  it 'is invalid without content' do
    comment.update(content: nil)
    expect(comment).to be_invalid
  end

  it 'is invalid with empty content' do
    comment.update(content: '    ')
    expect(comment).to be_invalid
  end

  it 'is invalid with too long content' do
    comment.update(content: Faker::Lorem.characters(256))
    expect(comment).to be_invalid
  end

  it 'is invalid without a report' do
    comment.update(report: nil)
    expect(comment).to be_invalid
  end

  it 'is invalid without a commenter' do
    comment.update(user: nil)
    expect(comment).to be_invalid
  end
end
