# frozen_string_literal: true

class Rental < ApplicationRecord
  belongs_to :book
  belongs_to :user

  scope :current, -> { where delivered_back_at: nil }
end
