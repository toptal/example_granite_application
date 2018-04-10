# frozen_string_literal: true

class CreateRents < ActiveRecord::Migration[5.1]
  def change
    create_table :rentals do |t|
      t.references :book, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamp :delivered_back_at

      t.timestamps
    end
  end
end
