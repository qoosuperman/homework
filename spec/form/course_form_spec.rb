# frozen_string_literal: true

require 'rails_helper'

describe CourseForm, type: :model do
  let(:form) { described_class.new(course) }
  let(:course) { build(:course) }

  let(:course_attributes) do
    {
      name: course_name,
      teacher_name: teacher_name,
      description: course_description,
      chapters: chapter_attributes
    }
  end
  let(:course_name) { 'course_name' }
  let(:teacher_name) { 'teacher_name' }
  let(:course_description) { 'course_description' }

  let(:chapter_attributes) do
    [
      {
        name: chapter1_name,
        sections: section_attributes
      },
      {
        name: chapter2_name,
        sections: section_attributes
      }
    ]
  end
  let(:chapter1_name) { 'chapter1_name' }
  let(:chapter2_name) { 'chapter2_name' }

  let(:section_attributes) do
    [
      {
        name: section1_name,
        description: section_description,
        detail: section_detail
      },
      {
        name: section2_name,
        description: section_description,
        detail: section_detail
      }
    ]
  end
  let(:section1_name) { 'section1_name' }
  let(:section2_name) { 'section2_name' }
  let(:section_description) { 'section_description' }
  let(:section_detail) { 'section_detail' }

  describe '#attributes=' do
    subject { form.attributes = course_attributes }
    context 'when create' do
      it 'all records should have assigned attributes' do
        subject
        expect(form.course.name).to eq('course_name')
        expect(form.course.teacher_name).to eq('teacher_name')
        expect(form.course.description).to eq('course_description')
        expect(form.course.chapters.first.name).to eq('chapter1_name')
        expect(form.course.chapters.first.order).to eq(1)
        expect(form.course.chapters.second.name).to eq('chapter2_name')
        expect(form.course.chapters.second.order).to eq(2)
        expect(form.course.chapters.first.sections.first.name).to eq('section1_name')
        expect(form.course.chapters.first.sections.first.description).to eq('section_description')
        expect(form.course.chapters.first.sections.first.detail).to eq('section_detail')
        expect(form.course.chapters.first.sections.second.name).to eq('section2_name')
        expect(form.course.chapters.first.sections.second.description).to eq('section_description')
        expect(form.course.chapters.first.sections.second.detail).to eq('section_detail')
      end
    end

    context 'when update' do
      let(:form) { described_class.new(existed_course) }
      let(:existed_course) { create(:course) }
      let(:existed_chapter) { create(:chapter, course: existed_course) }
      let(:existed_section) { create(:section, chapter: existed_chapter) }

      let(:course_attributes) do
        {
          name: course_name,
          teacher_name: teacher_name,
          description: course_description,
          chapters: chapter_attributes
        }
      end
      let(:chapter_attributes) do
        [
          {
            name: chapter1_name,
            sections: section_attributes1
          },
          {
            id: existed_chapter.id,
            name: chapter2_name,
            sections: section_attributes
          }
        ]
      end
      let(:section_attributes1) do
        [
          {
            name: section1_name,
            description: section_description,
            detail: section_detail
          },
          {
            id: existed_section.id,
            name: section2_name,
            description: section_description,
            detail: section_detail
          }
        ]
      end

      it 'all records should have assigned attributes' do
        subject
        first_chapter = form.course.chapters.find { |c| c.order == 1 }
        second_chapter = form.course.chapters.find { |c| c.order == 2 }
        first_section = first_chapter.sections.find { |c| c.order == 1 }
        second_section = first_chapter.sections.find { |c| c.order == 2 }

        expect(form.course.id).to eq(existed_course.id)
        expect(form.course.name).to eq('course_name')
        expect(form.course.teacher_name).to eq('teacher_name')
        expect(form.course.description).to eq('course_description')
        expect(first_chapter.name).to eq('chapter1_name')
        expect(second_chapter.name).to eq('chapter2_name')
        expect(second_chapter.id).to eq(existed_chapter.id)
        expect(first_section.name).to eq('section1_name')
        expect(first_section.description).to eq('section_description')
        expect(first_section.detail).to eq('section_detail')
        expect(second_section.id).to eq(existed_section.id)
        expect(second_section.name).to eq('section2_name')
        expect(second_section.description).to eq('section_description')
        expect(second_section.detail).to eq('section_detail')
      end
    end
  end

  describe 'validations' do
    subject do
      form.attributes = course_attributes
      form.valid?
    end

    context 'when all attributes are normal' do
      it { expect(subject).to be_truthy }
    end

    context 'when course is invalid' do
      let(:chapter1_name) { '' }
      it { expect(subject).to be_falsy }
    end

    context 'when chapter is invalid' do
      let(:section1_name) { '' }
      it { expect(subject).to be_falsy }
    end
  end

  describe '#save' do
    subject do
      form.attributes = course_attributes
      form.save
    end

    context 'when create' do
      it 'should have records created' do
        expect { subject }.to change { Course.all.size }.from(0).to(1).and \
          change { Chapter.all.size }.from(0).to(2).and \
            change { Section.all.size }.from(0).to(4)
        expect(form.course.name).to eq('course_name')
        expect(form.course.teacher_name).to eq('teacher_name')
        expect(form.course.description).to eq('course_description')
        expect(form.course.chapters.first.name).to eq('chapter1_name')
        expect(form.course.chapters.first.order).to eq(1)
        expect(form.course.chapters.second.name).to eq('chapter2_name')
        expect(form.course.chapters.second.order).to eq(2)
        expect(form.course.chapters.first.sections.first.name).to eq('section1_name')
        expect(form.course.chapters.first.sections.first.description).to eq('section_description')
        expect(form.course.chapters.first.sections.first.detail).to eq('section_detail')
        expect(form.course.chapters.first.sections.second.name).to eq('section2_name')
        expect(form.course.chapters.first.sections.second.description).to eq('section_description')
        expect(form.course.chapters.first.sections.second.detail).to eq('section_detail')
      end
    end

    context 'when update' do
      let(:form) { described_class.new(existed_course) }
      let!(:existed_course) { create(:course) }
      let!(:existed_chapter) { create(:chapter, course: existed_course) }
      let!(:existed_section) { create(:section, chapter: existed_chapter) }
      let(:course_attributes) do
        {
          name: course_name,
          teacher_name: teacher_name,
          description: course_description,
          chapters: chapter_attributes
        }
      end

      context 'when no records need to be destroy' do
        let(:chapter_attributes) do
          [
            {
              name: chapter1_name,
              sections: section_attributes1
            },
            {
              id: existed_chapter.id,
              name: chapter2_name,
              sections: section_attributes
            }
          ]
        end
        let(:section_attributes1) do
          [
            {
              name: section1_name,
              description: section_description,
              detail: section_detail
            },
            {
              id: existed_section.id,
              name: section2_name,
              description: section_description,
              detail: section_detail
            }
          ]
        end
        it 'all records should have assigned attributes and change record size' do
          expect { subject }.to change { Chapter.all.size }.from(1).to(2).and \
            change { Section.all.size }.from(1).to(4)
          expect(Course.all.size).to eq(1)

          first_chapter = form.course.chapters.find_by(order: 1)
          second_chapter = form.course.chapters.find_by(order: 2)
          first_section = first_chapter.sections.find_by(order: 1)
          second_section = first_chapter.sections.find_by(order: 2)
          expect(form.course.id).to eq(existed_course.id)
          expect(form.course.name).to eq('course_name')
          expect(form.course.teacher_name).to eq('teacher_name')
          expect(form.course.description).to eq('course_description')
          expect(first_chapter.name).to eq('chapter1_name')
          expect(second_chapter.name).to eq('chapter2_name')
          expect(second_chapter.id).to eq(existed_chapter.id)
          expect(first_section.name).to eq('section1_name')
          expect(first_section.description).to eq('section_description')
          expect(first_section.detail).to eq('section_detail')
          expect(second_section.id).to eq(existed_section.id)
          expect(second_section.name).to eq('section2_name')
          expect(second_section.description).to eq('section_description')
          expect(second_section.detail).to eq('section_detail')
        end
      end

      context 'when chapter and section are removed' do
        let(:chapter_attributes) do
          [
            {
              name: chapter1_name,
              sections: section_attributes1
            },
            {
              id: existed_chapter.id,
              name: chapter2_name,
              sections: section_attributes,
              _destroy: true
            }
          ]
        end
        let(:section_attributes1) do
          [
            {
              name: section1_name,
              description: section_description,
              detail: section_detail
            },
            {
              id: existed_section.id,
              name: section2_name,
              description: section_description,
              detail: section_detail,
              _destroy: true
            },
            {
              name: "#{section2_name}_new",
              description: section_description,
              detail: section_detail
            }
          ]
        end
        it 'the removed records should not affext orders' do
          expect { subject }.to change { Section.all.size }.from(1).to(2)
          expect(Course.all.size).to eq(1)
          expect(Chapter.all.size).to eq(1)

          first_chapter = form.course.chapters.first
          first_section = first_chapter.sections.find_by(order: 1)
          second_section = first_chapter.sections.find_by(order: 2)
          expect(form.course.id).to eq(existed_course.id)
          expect(form.course.name).to eq('course_name')
          expect(form.course.teacher_name).to eq('teacher_name')
          expect(form.course.description).to eq('course_description')
          expect(first_chapter.name).to eq('chapter1_name')
          expect(first_chapter.order).to eq(1)
          expect(first_section.name).to eq('section1_name')
          expect(first_section.description).to eq('section_description')
          expect(first_section.detail).to eq('section_detail')
          expect(second_section.name).to eq('section2_name_new')
          expect(second_section.description).to eq('section_description')
          expect(second_section.detail).to eq('section_detail')
        end
      end

      context 'when chapters and sections are all removed' do
        let(:chapter_attributes) do
          [
            {
              id: existed_chapter.id,
              name: chapter2_name,
              sections: section_attributes,
              _destroy: true
            }
          ]
        end
        let(:section_attributes1) do
          [
            {
              id: existed_section.id,
              name: section2_name,
              description: section_description,
              detail: section_detail,
              _destroy: true
            }
          ]
        end
        it 'should success and remove chapter and section' do
          expect { subject }.to change { Section.all.size }.from(1).to(0).and \
            change { Chapter.all.size }.from(1).to(0)
        end
      end
    end
  end
end
