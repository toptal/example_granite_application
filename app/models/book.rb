class Book < ApplicationRecord
  embeds_many :genres
  accepts_nested_attributes_for :genres

  def attributes
    super.merge('genres' => genres.map(&:title))
  end
end
