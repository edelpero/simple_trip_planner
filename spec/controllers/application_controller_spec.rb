require 'spec_helper'

describe ApplicationController, :type => :controller do

  controller do
    before_action :authenticate_user!

    def index
      render nothing: true
    end
  end

  describe 'GET#index' do
    context 'with a logged in user' do
      before do
        @user = FactoryGirl.create(:user)
        sign_in :user, @user
        sign_in @user
      end

      it 'returns status 200' do
        get :index
        expect(response.status).to eq(200)
      end

    end

    context 'without a logged in user' do
      it 'redirects to user sign in form' do
        get :index
        expect(response.status).to eq(302)
      end
    end
  end

end
