# frozen_string_literal: true

class Chapter < ActiveRecord::Base
  has_many :sections, autosave: true, dependent: :destroy
  belongs_to :course

  validates :name, presence: true

  scope :in_order, -> { order(:order) }
end
