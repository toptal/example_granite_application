# frozen_string_literal: true

class BA::Book::Rent < BaseAction
  allow_if { performer.is_a?(User) }

  subject :book

  precondition do
    decline_with(:unavailable) unless book.available?
  end

  private

  def execute_perform!(*)
    subject.available = false
    subject.save!
    ::Rental.create!(book: subject, user: performer)
  end
end
