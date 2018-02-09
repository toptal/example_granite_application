class Book < ApplicationRecord
  embeds_many :genres

  def attributes
    super.merge('genres' => genres.map(&:title))
  end
end
