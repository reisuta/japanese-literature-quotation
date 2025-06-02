require 'rails_helper'

RSpec.describe "Api::V1::Kanjis", type: :request do
  let!(:kanji1) { create(:kanji, grade: '1', stroke_count: 5) }
  let!(:kanji2) { create(:kanji, grade: '2', stroke_count: 10) }
  let!(:kanji3) { create(:kanji, grade: '1', stroke_count: 8) }
  let!(:tag) { create(:tag, name: 'elementary') }

  before do
    kanji1.tags << tag
  end

  describe "GET /api/v1/kanjis" do
    context "without filters" do
      it "returns all kanjis" do
        get "/api/v1/kanjis", headers: { 'Accept' => 'application/json' }
        
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(3)
      end
    end

    context "with grade filter" do
      it "returns kanjis filtered by grade" do
        get "/api/v1/kanjis", params: { grade: '1' }, headers: { 'Accept' => 'application/json' }
        
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(2)
      end
    end

    context "with stroke_count filter" do
      it "returns kanjis filtered by stroke count" do
        get "/api/v1/kanjis", params: { stroke_count: 5 }, headers: { 'Accept' => 'application/json' }
        
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(1)
      end
    end

    context "with typing purpose" do
      it "returns kanjis in typing format" do
        get "/api/v1/kanjis", params: { purpose: 'typing' }, headers: { 'Accept' => 'application/json' }
        
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to be_an(Array)
        expect(json_response.first).to be_an(Array)
        expect(json_response.first.size).to eq(3) # [reading_on, character, meaning]
      end

      it "limits results when limit parameter is provided" do
        create_list(:kanji, 15)
        get "/api/v1/kanjis", params: { purpose: 'typing', limit: 5 }, headers: { 'Accept' => 'application/json' }
        
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(5)
      end
    end
  end

  describe "GET /api/v1/kanjis/:id" do
    context "when kanji exists" do
      it "returns the kanji" do
        get "/api/v1/kanjis/#{kanji1.id}", headers: { 'Accept' => 'application/json' }
        
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(kanji1.id)
        expect(json_response['character']).to eq(kanji1.character)
      end
    end

    context "when kanji does not exist" do
      it "returns not found error" do
        get "/api/v1/kanjis/999999", headers: { 'Accept' => 'application/json' }
        
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('漢字が見つかりません')
      end
    end
  end

  describe "GET /api/v1/kanjis/random" do
    it "returns a random kanji" do
      get "/api/v1/kanjis/random", headers: { 'Accept' => 'application/json' }
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['id']).to be_in([kanji1.id, kanji2.id, kanji3.id])
    end
  end

  describe "GET /api/v1/grades/:grade/kanjis" do
    it "returns kanjis by grade" do
      get "/api/v1/grades/1/kanjis", headers: { 'Accept' => 'application/json' }
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(2)
      json_response.each do |kanji|
        expect(kanji['grade']).to eq('1')
      end
    end
  end

  describe "GET /api/v1/tags/:id/kanjis" do
    context "when tag exists" do
      it "returns kanjis associated with the tag" do
        get "/api/v1/tags/#{tag.id}/kanjis", headers: { 'Accept' => 'application/json' }
        
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(1)
        expect(json_response.first['id']).to eq(kanji1.id)
      end
    end

    context "when tag does not exist" do
      it "returns not found error" do
        get "/api/v1/tags/99999/kanjis", headers: { 'Accept' => 'application/json' }
        
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('タグが見つかりません')
      end
    end
  end
end