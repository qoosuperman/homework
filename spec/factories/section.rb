# frozen_string_literal: true

FactoryBot.define do
  factory :section do
    association :chapter
    sequence(:name) { |n| "section#{n}" }
    sequence(:description) { |n| "section_description#{n}" }
    sequence(:detail) { |n| "section_deatil#{n}" }
    sequence(:order) { |n| n }
  end
end
