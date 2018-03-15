# frozen_string_literal: true

class AddAvailabilityToBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :available, :boolean, default: true
  end
end
