# frozen_string_literal: true

FactoryBot.define do
  factory :course do
    sequence(:name) { |n| "course#{n}" }
    sequence(:teacher_name) { |n| "teacher#{n}" }
    sequence(:description) { |n| "course_description#{n}" }

    trait :with_chapters do
      after(:create) do |course|
        create_list(:chapter, 2, :with_sections, course: course)
      end
    end
  end
end
