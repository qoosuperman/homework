# frozen_string_literal: true

class CreateSections < ActiveRecord::Migration[6.1]
  def change
    create_table :sections do |t|
      t.references :chapter
      t.references :course
      t.string :name, null: false
      t.text :description, null: false
      t.text :detail
      t.integer :order, null: false

      t.timestamps
    end
  end
end
