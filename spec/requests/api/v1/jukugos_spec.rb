require 'rails_helper'

RSpec.describe "Api::V1::Jukugos", type: :request do
  let!(:jukugo1) { create(:jukugo, difficulty: 'beginner') }
  let!(:jukugo2) { create(:jukugo, difficulty: 'intermediate') }
  let!(:jukugo3) { create(:jukugo, difficulty: 'beginner') }
  let!(:tag) { create(:tag, name: 'basic') }

  before do
    jukugo1.tags << tag
  end

  describe "GET /api/v1/jukugos" do
    context "without filters" do
      it "returns all jukugos" do
        get "/api/v1/jukugos", headers: { 'Accept' => 'application/json' }
        
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(3)
      end
    end

    context "with difficulty filter" do
      it "returns jukugos filtered by difficulty" do
        get "/api/v1/jukugos", params: { difficulty: 'beginner' }, headers: { 'Accept' => 'application/json' }
        
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(2)
      end
    end

    context "with typing purpose" do
      it "returns jukugos in typing format" do
        get "/api/v1/jukugos", params: { purpose: 'typing' }, headers: { 'Accept' => 'application/json' }
        
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to be_an(Array)
        expect(json_response.first).to be_an(Array)
        expect(json_response.first.size).to eq(3) # [reading_alphabet, expression, meaning]
      end

      it "limits results when limit parameter is provided" do
        create_list(:jukugo, 15)
        get "/api/v1/jukugos", params: { purpose: 'typing', limit: 5 }, headers: { 'Accept' => 'application/json' }
        
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(5)
      end
    end
  end

  describe "GET /api/v1/jukugos/:id" do
    context "when jukugo exists" do
      it "returns the jukugo" do
        get "/api/v1/jukugos/#{jukugo1.id}", headers: { 'Accept' => 'application/json' }
        
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(jukugo1.id)
        expect(json_response['expression']).to eq(jukugo1.expression)
      end
    end

    context "when jukugo does not exist" do
      it "returns not found error" do
        get "/api/v1/jukugos/999999", headers: { 'Accept' => 'application/json' }
        
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('熟語が見つかりません')
      end
    end
  end

  describe "GET /api/v1/jukugos/random" do
    it "returns a random jukugo" do
      get "/api/v1/jukugos/random", headers: { 'Accept' => 'application/json' }
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['id']).to be_in([jukugo1.id, jukugo2.id, jukugo3.id])
    end
  end

  describe "GET /api/v1/difficulty/:difficulty/jukugos" do
    it "returns jukugos by difficulty" do
      get "/api/v1/difficulty/beginner/jukugos", headers: { 'Accept' => 'application/json' }
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(2)
      json_response.each do |jukugo|
        expect(jukugo['difficulty']).to eq('beginner')
      end
    end
  end

  describe "GET /api/v1/tags/:id/jukugos" do
    context "when tag exists" do
      it "returns jukugos associated with the tag" do
        get "/api/v1/tags/#{tag.id}/jukugos", headers: { 'Accept' => 'application/json' }
        
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(1)
        expect(json_response.first['id']).to eq(jukugo1.id)
      end
    end

    context "when tag does not exist" do
      it "returns not found error" do
        get "/api/v1/tags/99999/jukugos", headers: { 'Accept' => 'application/json' }
        
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('タグが見つかりません')
      end
    end
  end
end