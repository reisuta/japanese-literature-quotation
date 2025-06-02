require 'rails_helper'

RSpec.describe Jukugo, type: :model do
  describe 'validations' do
    subject { build(:jukugo) }

    it { should validate_presence_of(:expression) }
    it { should validate_uniqueness_of(:expression).case_insensitive }
    it { should validate_presence_of(:reading) }
    it { should validate_presence_of(:reading_alphabet) }
    it { should validate_presence_of(:meaning) }
    it { should validate_presence_of(:difficulty) }
  end

  describe 'associations' do
    it { should have_many(:jukugo_tags).dependent(:destroy) }
    it { should have_many(:tags).through(:jukugo_tags) }
  end

  describe 'scopes' do
    let!(:jukugo1) { create(:jukugo, difficulty: 'beginner') }
    let!(:jukugo2) { create(:jukugo, difficulty: 'intermediate') }
    let!(:jukugo3) { create(:jukugo, difficulty: 'beginner') }

    describe '.by_difficulty' do
      it 'returns jukugos with specified difficulty' do
        expect(Jukugo.by_difficulty('beginner')).to contain_exactly(jukugo1, jukugo3)
      end
    end

    describe '.random_sample' do
      it 'returns limited number of jukugos' do
        expect(Jukugo.random_sample(2).count).to eq(2)
      end

      it 'defaults to 10 when no limit specified' do
        create_list(:jukugo, 15)
        expect(Jukugo.random_sample.count).to eq(10)
      end
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:jukugo)).to be_valid
    end

    it 'creates unique expressions' do
      jukugo1 = create(:jukugo)
      jukugo2 = create(:jukugo)
      expect(jukugo1.expression).not_to eq(jukugo2.expression)
    end
  end
end
