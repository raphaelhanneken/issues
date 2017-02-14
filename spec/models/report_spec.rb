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

RSpec.describe Report, type: :model do
  let(:report) { FactoryGirl.build(:report) }

  it { is_expected.to belong_to(:project) }
  it { is_expected.to belong_to(:reporter) }
  it { is_expected.to belong_to(:assignee) }
  it { is_expected.to have_and_belong_to_many(:labels) }
  it { is_expected.to have_many(:comments) }

  it 'has a valid factory' do
    expect(report).to be_valid
  end

  it 'saves a valid instance' do
    expect do
      report.save!
    end.to change(Report, :count).by(1)
  end

  it 'is invalid without title' do
    report.update(title: nil)
    expect(report).to be_invalid
  end

  it 'is invalid with an empty title' do
    report.update(title: '      ')
    expect(report).to be_invalid
  end

  it 'is invalid with a too long title' do
    report.update(title: Faker::Lorem.characters(81))
    expect(report).to be_invalid
  end

  it 'is invalid without a description' do
    report.update(description: nil)
    expect(report).to be_invalid
  end

  it 'is invalid with an empty description' do
    report.update(description: '   ')
    expect(report).to be_invalid
  end

  it 'is invalid with a too long description' do
    report.update(description: Faker::Lorem.characters(1001))
    expect(report).to be_invalid
  end

  it 'is invalid without an associated project' do
    report.update(project: nil)
    expect(report).to be_invalid
  end

  it 'is invalid without a reporter' do
    report.update(reporter: nil)
    expect(report).to be_invalid
  end

  it 'is open by default' do
    expect(report.closed).to be_falsey
  end

  it 'can be closed' do
    report.update(closed: true)
    expect(report.closed).to be_truthy
  end

  it 'responds to :inbox' do
    expect(Report).to respond_to(:inbox)
  end

  it 'responds to :assigned_to' do
    expect(Report).to respond_to(:assigned_to)
  end

  it 'responds to :reported_by' do
    expect(Report).to respond_to(:reported_by)
  end

  it 'responds to :unassigned' do
    expect(Report).to respond_to(:unassigned)
  end

  it 'responds to :open' do
    expect(Report).to respond_to(:open)
  end

  it 'responds to :closed' do
    expect(Report).to respond_to(:closed)
  end

  it 'deletes associated comments on #destroy' do
    report = FactoryGirl.create(:report_with_comments)
    expect do
      report.destroy
    end.to change(Comment, :count).by(-3)
  end
end
