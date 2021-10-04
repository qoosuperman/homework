# frozen_string_literal: true

require 'rails_helper'

describe Section, type: :model do
  let(:chapter) { build(:chapter, :with_sections, name: name) }
  let(:name) { 'chapter_name' }

  describe 'validations' do
    subject { chapter.valid? }

    context 'when normal' do
      it 'should be valid' do
        expect(subject).to be_truthy
      end
    end

    context 'when no name given' do
      let(:name) { '' }
      it 'should not be valid' do
        expect(subject).to be_falsy
      end
    end
  end

  describe '.in_order' do
    subject { Chapter.in_order }
    let!(:chapter_with_big_order) { create(:chapter, id: 1, order: 2, name: 'chapter1') }
    let!(:chapter_with_small_order) { create(:chapter, id: 2, order: 1, name: 'chapter2') }

    it 'should get chapters sorted by order' do
      expect(subject.first.name).to eq('chapter2')
      expect(subject.second.name).to eq('chapter1')
    end
  end
end
