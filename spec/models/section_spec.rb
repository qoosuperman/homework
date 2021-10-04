# frozen_string_literal: true

require 'rails_helper'

describe Section, type: :model do
  let(:section) { build(:section, name: name, description: description) }
  let(:name) { 'section_name' }
  let(:description) { 'section_description' }

  describe 'validations' do
    subject { section.valid? }

    context 'when normal' do
      it 'should change section count by 1' do
        expect(subject).to be_truthy
      end
    end

    context 'when no name given' do
      let(:name) { '' }
      it 'should not change section count and raise error' do
        expect(subject).to be_falsy
      end
    end

    context 'when no description given' do
      let(:description) { '' }
      it 'should not change section count and raise error' do
        expect(subject).to be_falsy
      end
    end

    describe '.in_order' do
      subject { Section.in_order }
      let!(:section_with_big_order) { create(:section, id: 1, order: 2, name: 'section1') }
      let!(:section_with_small_order) { create(:section, id: 2, order: 1, name: 'section2') }

      it 'should get chapters sorted by order' do
        expect(subject.first.name).to eq('section2')
        expect(subject.second.name).to eq('section1')
      end
    end
  end
end
