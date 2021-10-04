# frozen_string_literal: true

class Course < ActiveRecord::Base
  has_many :chapters, autosave: true, dependent: :destroy
  has_many :sections

  validates :name, :teacher_name, presence: true
end
