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

RSpec.describe Project, type: :model do
  let(:project) { FactoryGirl.build(:project) }

  it { is_expected.to have_many(:reports) }

  it 'has a valid factory' do
    expect(project).to be_valid
  end

  it 'saves a valid instance' do
    expect {
      project.save!
    }.to change(Project, :count).by(1)
  end

  it 'is invalid without name' do
    project.update(name: nil)
    expect(project).to be_invalid
  end

  it 'is invalid with an empty name' do
    project.update(name: '     ')
    expect(project).to be_invalid
  end

  it 'is invalid with a too long name' do
    project.update(name: Faker::Lorem.characters(81))
    expect(project).to be_invalid
  end

  it 'deletes the associated reports on #destroy' do
    FactoryGirl.create(:project_with_reports)

    expect {
      Project.last.destroy
    }.to change(Report, :count).by(-3)
  end
end
