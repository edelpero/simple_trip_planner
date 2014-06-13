require 'spec_helper'

describe User, :type => :model do
  describe 'associations' do
    it { should have_many(:trips) }
  end
end
