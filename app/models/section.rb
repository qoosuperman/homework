# frozen_string_literal: true

# description 單元內容 (必填)
# deatil 單元說明 (非必填)

class Section < ActiveRecord::Base
  belongs_to :chapter
  belongs_to :course, optional: true

  validates :name, :description, presence: true

  scope :in_order, -> { order(:order) }

  before_save do
    self.course = chapter.course
  end
end
