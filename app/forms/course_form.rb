# frozen_string_literal: true

class CourseForm < BaseForm
  attr_reader :course

  validate :validates_course

  def initialize(course)
    @course = course
  end

  def attributes=(attributes)
    course.attributes = attributes.slice(:name, :teacher_name, :description)
    chapter_order = 1
    attributes[:chapters].each do |chapter_attrs|
      existed_chapter = course.chapters.detect { |c| c.id == chapter_attrs[:id].to_i }
      existed_chapter.mark_for_destruction && next if chapter_attrs[:_destroy] && existed_chapter

      attrs = chapter_attrs.slice(:name).merge(order: chapter_order)
      chapter = if existed_chapter
                  existed_chapter.attributes = attrs
                  existed_chapter
                else
                  course.chapters.build(attrs)
                end
      chapter_order += 1
      section_order = 1
      chapter_attrs[:sections].each do |section_attrs|
        existed_section = course.sections.detect { |s| s.id == section_attrs[:id].to_i }
        existed_section.mark_for_destruction && next if section_attrs[:_destroy] && existed_section

        attrs = section_attrs.slice(:name, :description, :detail).merge(order: section_order)
        if existed_section
          existed_section.attributes = attrs
          chapter.sections << existed_section
        else
          chapter.sections.build(attrs)
        end
        section_order += 1
      end
    end
  end

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      course.chapters.each do |chapter|
        chapter.sections.each do |section|
          section.destroy! if section.marked_for_destruction?
        end
        chapter.destroy! if chapter.marked_for_destruction?
      end
      course.save!
    end
    true
  end

  private

  def validates_course
    promote_errors(course.errors) if course.invalid?
  end
end
