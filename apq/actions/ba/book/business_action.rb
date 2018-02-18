class BA::Book::BusinessAction < BaseAction
  allow_if { performer.is_a?(User) }

  represents :title, of: :subject

  embeds_many :genres

  accepts_nested_attributes_for :genres

  validates :title, presence: true

  private

  def execute_perform!(*)
    subject.genres = genres
    subject.save!
  end
end
