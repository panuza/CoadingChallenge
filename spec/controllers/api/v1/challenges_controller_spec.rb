require 'rails_helper'

describe Api::V1::ChallengesController, type: :controller do
  render_views

  describe "challenges controller" do 
    before do 
      @user = User.make!
      @challenge = Challenge.make!(user_id: @user.id)
      emulate_user_login(@user)
    end 

    describe 'GET#index' do
      it 'returns JSON response' do
        get :index
        
        expect(response.status).to eq 200
        challenges = JSON.parse(response.body)
        challenge = challenges["challenges"].last
        expect(challenge["id"]).to eq @challenge.id
      end
    end


    # describe 'POST #show' do
    #   it 'should show' do
    #     get :show, params: { :id => @gallery.permalink, permalink: @company.permalink }
    #     expect(response).to be_successful

    #   end
    # end 

    # describe 'POST #destroy' do
    #   it 'should destroy' do
    #     expect(Gallery.count).to eq 1
    #     delete :destroy , params: { id: @gallery.permalink, permalink: @company.permalink }

    #     expect(Gallery.count).to eq 0
    #   end
    # end

    # describe 'POST #create' do
    #   it 'should create' do
    #     Gallery.destroy_all
    #     expect(Gallery.count).to eq 0
    #     post :create, params: { permalink: @company.permalink, company_gallery: { description: "test", title: "This is title", date_of_completion: Date.today} }
    #     expect(Gallery.count).to eq 1

    #     expect(Gallery.last.title).to eq 'This is title'

    #   end
    # end
  end 
end
