# frozen_string_literal: true

class CreateChapters < ActiveRecord::Migration[6.1]
  def change
    create_table :chapters do |t|
      t.references :course
      t.string :name, null: false
      t.integer :order, null: false

      t.timestamps
    end
  end
end
