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

RSpec.describe Label, type: :model do
  let(:label) { FactoryGirl.build(:label) }

  it { is_expected.to have_and_belong_to_many(:reports) }

  it 'has a valid factory' do
    expect(label).to be_valid
  end

  it 'saves a valid instance' do
    expect do
      label.save!
    end.to change(Label, :count).by(1)
  end

  it 'is invalid without a title' do
    label.update(title: nil)
    expect(label).to be_invalid
  end

  it 'is invalid with an empty title' do
    label.update(title: '   ')
    expect(label).to be_invalid
  end

  it 'is invalid with a too long title' do
    label.update(title: Faker::Lorem.characters(51))
    expect(label).to be_invalid
  end

  it 'is invalid without a color' do
    label.update(color: nil)
    expect(label).to be_invalid
  end

  it 'is invalid with an empty color' do
    label.update(color: '    ')
    expect(label).to be_invalid
  end

  it 'is invalid when color doesnt start with #' do
    label.update(color: 'f3f3f36')
    expect(label).to be_invalid
  end

  it 'is invalid with a too short color' do
    label.update(color: '#ffff')
    expect(label).to be_invalid
  end

  it 'is invalid with a too long color' do
    label.update(color: '#fafafaf')
    expect(label).to be_invalid
  end
end
