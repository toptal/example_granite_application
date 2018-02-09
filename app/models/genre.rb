class Genre
  include ActiveData::Model
  include ActiveData::Model::Lifecycle

  attribute :title, String
  validates :title, presence: true
end

