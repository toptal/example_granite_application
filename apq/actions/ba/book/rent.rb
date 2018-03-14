# frozen_string_literal: true

class BA::Book::Rent < BaseAction
  allow_if { performer.is_a?(User) }

  subject :book

  precondition do
    decline_with(:unavailable) unless book.available?
  end

  private

  def execute_perform!(*)
    ::Rent.create!(book: subject, user: performer)
    subject.available = false
    subject.save!
  end
end
