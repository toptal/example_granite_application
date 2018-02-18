class Genre < ActiveData::Base
  attribute :title, String
  attribute :id, ActiveData::UUID, default: ActiveData::UUID.random_create
  validates :title, presence: true

  primary :id
end

