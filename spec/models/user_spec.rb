require 'spec_helper'

describe User, :type => :model do
  describe 'associations' do
    it { should have_many(:trips) }
  end

  describe 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:name) }
  end
end
