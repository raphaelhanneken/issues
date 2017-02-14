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

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.build(:user) }

  it { is_expected.to have_many(:reported) }

  it { is_expected.to have_many(:assigned) }

  it { is_expected.to have_many(:comments) }

  it 'has a valid factory' do
    expect(user).to be_valid
  end

  it 'saves a valid instance' do
    expect do
      user.save!
    end.to change(User, :count).by(1)
  end

  it 'is invalid without a firstname' do
    user.update(firstname: nil)
    expect(user).to be_invalid
  end

  it 'is invalid with an empty firstname' do
    user.update(firstname: '    ')
    expect(user).to be_invalid
  end

  it 'is invalid with a too short firstname' do
    user.update(firstname: 'a')
    expect(user).to be_invalid
  end

  it 'is invalid with a too long firstname' do
    user.update(firstname: Faker::Lorem.sentence(26))
    expect(user).to be_invalid
  end

  it 'is invalid without a lastname' do
    user.update(lastname: nil)
    expect(user).to be_invalid
  end

  it 'is invalid with an empty lastname' do
    user.update(lastname: '    ')
    expect(user).to be_invalid
  end

  it 'is invalid with a too short lastname' do
    user.update(lastname: 'a')
    expect(user).to be_invalid
  end

  it 'is invalid with a too long lastname' do
    user.update(lastname: Faker::Lorem.sentence(26))
    expect(user).to be_invalid
  end

  it 'has no admin rights by default' do
    expect(user.admin).to be_falsy
  end

  it 'responds to :name' do
    expect(user.name).to eq("#{user.firstname} #{user.lastname}")
  end

  describe 'on #destroy' do
    let!(:reporter)  { FactoryGirl.create(:reporter) }
    let!(:assignee)  { FactoryGirl.create(:assignee) }
    let!(:commenter) { FactoryGirl.create(:commenter) }
    let!(:reported)  { reporter.reported }
    let!(:assigned)  { assignee.assigned }
    let!(:comments)  { commenter.comments }

    it 'sets reporter to nil' do
      reporter.destroy
      reported.each do |r|
        expect(r).to be_a(Report)
      end
    end

    it 'sets assignee to nil' do
      assignee.destroy
      assigned.each do |r|
        expect(r.assignee).to eq(nil)
      end
    end

    it 'sets comments to nil' do
      commenter.destroy
      comments.each do |c|
        expect(c.user).to eq(nil)
      end
    end
  end
end
