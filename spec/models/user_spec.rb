require 'spec_helper'

describe User, :type => :model do
  describe 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:name) }
  end
end
