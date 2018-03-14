# frozen_string_literal: true

class Rent < ApplicationRecord
  belongs_to :book
  belongs_to :user
end
