require 'rails_helper'

RSpec.describe "Api::V1::Scores", type: :request do
  let!(:score1) { create(:score, user_name: 'user1', score_type: 'quotes', wpm: 50.0) }
  let!(:score2) { create(:score, user_name: 'user2', score_type: 'kanjis', wpm: 40.0) }
  let!(:score3) { create(:score, user_name: 'user1', score_type: 'jukugos', wpm: 60.0) }

  describe "GET /api/v1/scores" do
    context "without filters" do
      it "returns all scores" do
        get "/api/v1/scores", headers: { 'Accept' => 'application/json' }
        
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(3)
      end

      it "limits results to 50 by default" do
        create_list(:score, 60)
        get "/api/v1/scores", headers: { 'Accept' => 'application/json' }
        
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(50)
      end
    end

    context "with score_type filter" do
      it "returns scores filtered by score type" do
        get "/api/v1/scores", params: { score_type: 'quotes' }, headers: { 'Accept' => 'application/json' }
        
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(1)
        expect(json_response.first['score_type']).to eq('quotes')
      end
    end

    context "with user_name filter" do
      it "returns scores filtered by user" do
        get "/api/v1/scores", params: { user_name: 'user1' }, headers: { 'Accept' => 'application/json' }
        
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(2)
        json_response.each do |score|
          expect(score['user_name']).to eq('user1')
        end
      end
    end

    context "with limit parameter" do
      it "limits results when limit parameter is provided" do
        get "/api/v1/scores", params: { limit: 2 }, headers: { 'Accept' => 'application/json' }
        
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(2)
      end
    end
  end

  describe "GET /api/v1/scores/:id" do
    context "when score exists" do
      it "returns the score" do
        get "/api/v1/scores/#{score1.id}", headers: { 'Accept' => 'application/json' }
        
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(score1.id)
        expect(json_response['user_name']).to eq(score1.user_name)
      end
    end

    context "when score does not exist" do
      it "returns not found error" do
        get "/api/v1/scores/999999", headers: { 'Accept' => 'application/json' }
        
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('スコアが見つかりません')
      end
    end
  end

  describe "POST /api/v1/scores" do
    let(:valid_params) do
      {
        score: {
          user_name: 'testuser',
          score_type: 'quotes',
          wpm: 45.5,
          accuracy: 92.3,
          time_taken: 120.5,
          completed_at: Time.current.iso8601
        }
      }
    end

    context "with valid parameters" do
      it "creates a new score" do
        expect {
          post "/api/v1/scores", params: valid_params, headers: { 'Accept' => 'application/json' }
        }.to change(Score, :count).by(1)
        
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['user_name']).to eq('testuser')
        expect(json_response['wpm']).to eq(45.5)
      end
    end

    context "with invalid parameters" do
      it "returns validation errors" do
        invalid_params = valid_params.deep_dup
        invalid_params[:score][:wpm] = -1
        invalid_params[:score][:user_name] = ''
        
        post "/api/v1/scores", params: invalid_params, headers: { 'Accept' => 'application/json' }
        
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to be_present
      end
    end

    context "with invalid score type" do
      it "returns validation error" do
        invalid_params = valid_params.deep_dup
        invalid_params[:score][:score_type] = 'invalid'
        
        post "/api/v1/scores", params: invalid_params, headers: { 'Accept' => 'application/json' }
        
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include('Score type is not included in the list')
      end
    end
  end

  describe "GET /api/v1/leaderboard/:score_type" do
    let!(:high_score) { create(:score, :high_score, score_type: 'quotes') }
    let!(:low_score) { create(:score, :low_score, score_type: 'quotes') }

    it "returns top scores for specified type" do
      get "/api/v1/leaderboard/quotes", headers: { 'Accept' => 'application/json' }
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.first['wpm']).to eq(80.0) # high_score should be first
    end

    it "defaults to quotes when no score_type specified" do
      get "/api/v1/leaderboard/quotes", headers: { 'Accept' => 'application/json' }
      
      expect(response).to have_http_status(:ok)
    end

    it "limits results when limit parameter is provided" do
      create_list(:score, 15, score_type: 'quotes')
      get "/api/v1/leaderboard/quotes", params: { limit: 5 }, headers: { 'Accept' => 'application/json' }
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(5)
    end
  end

  describe "GET /api/v1/users/:user_name/stats" do
    it "returns user statistics" do
      get "/api/v1/users/user1/stats", headers: { 'Accept' => 'application/json' }
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      
      expect(json_response['total_games']).to eq(2)
      expect(json_response['average_wpm']).to be_present
      expect(json_response['average_accuracy']).to be_present
      expect(json_response['best_wpm']).to be_present
      expect(json_response['best_accuracy']).to be_present
      expect(json_response['recent_scores']).to be_an(Array)
    end

    it "returns empty stats for non-existent user" do
      get "/api/v1/users/nonexistent/stats", headers: { 'Accept' => 'application/json' }
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['total_games']).to eq(0)
    end
  end
end