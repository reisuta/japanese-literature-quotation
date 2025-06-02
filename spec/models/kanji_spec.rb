require 'rails_helper'

RSpec.describe Kanji, type: :model do
  describe 'validations' do
    subject { build(:kanji) }

    it { should validate_presence_of(:character) }
    it { should validate_uniqueness_of(:character).case_insensitive }
    it { should validate_presence_of(:reading_on) }
    it { should validate_presence_of(:reading_kun) }
    it { should validate_presence_of(:meaning) }
    it { should validate_presence_of(:grade) }
    it { should validate_presence_of(:stroke_count) }
    it { should validate_numericality_of(:stroke_count).is_greater_than(0) }
  end

  describe 'associations' do
    it { should have_many(:kanji_tags).dependent(:destroy) }
    it { should have_many(:tags).through(:kanji_tags) }
  end

  describe 'scopes' do
    let!(:kanji1) { create(:kanji, grade: '1', stroke_count: 5) }
    let!(:kanji2) { create(:kanji, grade: '2', stroke_count: 10) }
    let!(:kanji3) { create(:kanji, grade: '1', stroke_count: 8) }

    describe '.by_grade' do
      it 'returns kanjis with specified grade' do
        expect(Kanji.by_grade('1')).to contain_exactly(kanji1, kanji3)
      end
    end

    describe '.by_stroke_count' do
      it 'returns kanjis with specified stroke count' do
        expect(Kanji.by_stroke_count(5)).to contain_exactly(kanji1)
      end
    end

    describe '.random_sample' do
      it 'returns limited number of kanjis' do
        expect(Kanji.random_sample(2).count).to eq(2)
      end

      it 'defaults to 10 when no limit specified' do
        create_list(:kanji, 15)
        expect(Kanji.random_sample.count).to eq(10)
      end
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:kanji)).to be_valid
    end

    it 'creates unique characters' do
      kanji1 = create(:kanji)
      kanji2 = create(:kanji)
      expect(kanji1.character).not_to eq(kanji2.character)
    end
  end
end
