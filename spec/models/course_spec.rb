# frozen_string_literal: true

require 'rails_helper'

describe Course, type: :model do
  let(:course) { build(:course, name: name, teacher_name: teacher_name) }
  let(:name) { 'course_name' }
  let(:teacher_name) { 'teacher_name' }

  describe 'validations' do
    subject { course.valid? }

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

    context 'when no teacher_name given' do
      let(:teacher_name) { '' }
      it 'should not be valid' do
        expect(subject).to be_falsy
      end
    end
  end
end
