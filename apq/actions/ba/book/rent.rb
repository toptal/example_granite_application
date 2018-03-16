# frozen_string_literal: true

class Ba::Book::Rent < BaseAction
  allow_if { !performer.renting?(subject) }
  allow_if { performer.is_a?(User) }

  projector :inline

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
