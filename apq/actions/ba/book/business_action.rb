# frozen_string_literal: true

class Ba::Book::BusinessAction < BaseAction
  allow_if { performer.is_a?(User) }

  represents :title, of: :subject

  validates :title, presence: true

  private

  def execute_perform!(*)
    subject.save!
  end
end
