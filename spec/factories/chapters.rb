# frozen_string_literal: true

FactoryBot.define do
  factory :chapter do
    association :course
    sequence(:name) { |n| "chapter#{n}" }
    sequence(:order) { |n| n }

    trait :with_sections do
      after(:create) do |chapter|
        create_list(:section, 2, chapter: chapter)
      end
    end
  end
end
