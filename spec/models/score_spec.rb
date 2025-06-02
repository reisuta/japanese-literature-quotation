require 'rails_helper'

RSpec.describe Score, type: :model do
  describe 'validations' do
    subject { build(:score) }

    it { should validate_presence_of(:user_name) }
    it { should validate_presence_of(:score_type) }
    it { should validate_inclusion_of(:score_type).in_array(%w[quotes kanjis jukugos]) }
    it { should validate_presence_of(:wpm) }
    it { should validate_numericality_of(:wpm).is_greater_than(0) }
    it { should validate_presence_of(:accuracy) }
    it { should validate_numericality_of(:accuracy).is_in(0.0..100.0) }
    it { should validate_presence_of(:time_taken) }
    it { should validate_numericality_of(:time_taken).is_greater_than(0) }
    it { should validate_presence_of(:completed_at) }
  end

  describe 'scopes' do
    let!(:user1_quotes) { create(:score, user_name: 'user1', score_type: 'quotes', wpm: 50.0) }
    let!(:user1_kanjis) { create(:score, :kanji_score, user_name: 'user1', wpm: 40.0) }
    let!(:user2_quotes) { create(:score, user_name: 'user2', score_type: 'quotes', wpm: 60.0) }
    let!(:high_score) { create(:score, :high_score, completed_at: 1.day.ago) }
    let!(:low_score) { create(:score, :low_score, completed_at: 2.days.ago) }

    describe '.by_score_type' do
      it 'returns scores of specified type' do
        expect(Score.by_score_type('quotes')).to contain_exactly(user1_quotes, user2_quotes, high_score, low_score)
      end

      it 'returns kanji scores' do
        expect(Score.by_score_type('kanjis')).to contain_exactly(user1_kanjis)
      end
    end

    describe '.by_user' do
      it 'returns scores for specified user' do
        expect(Score.by_user('user1')).to contain_exactly(user1_quotes, user1_kanjis)
      end
    end

    describe '.recent' do
      it 'returns scores ordered by completion date descending' do
        expect(Score.recent.first.completed_at).to be >= Score.recent.last.completed_at
      end
    end

    describe '.top_scores' do
      it 'returns highest WPM scores' do
        expect(Score.top_scores(2).first.wpm).to eq(80.0) # high_score
      end

      it 'defaults to top 10' do
        create_list(:score, 15)
        expect(Score.top_scores.count).to eq(10)
      end
    end
  end

  describe 'factory traits' do
    it 'creates kanji score with trait' do
      score = build(:score, :kanji_score)
      expect(score.score_type).to eq('kanjis')
    end

    it 'creates jukugo score with trait' do
      score = build(:score, :jukugo_score)
      expect(score.score_type).to eq('jukugos')
    end

    it 'creates high score with trait' do
      score = build(:score, :high_score)
      expect(score.wpm).to eq(80.0)
      expect(score.accuracy).to eq(98.0)
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:score)).to be_valid
    end

    it 'creates valid score with all required attributes' do
      score = create(:score)
      expect(score.user_name).to be_present
      expect(score.score_type).to be_present
      expect(score.wpm).to be > 0
      expect(score.accuracy).to be_between(0, 100)
      expect(score.time_taken).to be > 0
      expect(score.completed_at).to be_present
    end
  end
end
