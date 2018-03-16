class Ba::Book::DeliverBack < BaseAction

  subject :book

  projector :inline

  allow_if { rental.present? }

  def rental
    @rental ||= performer.rentals.current.find_by(book: book)
  end

  private

  def execute_perform!(*)
    rental.delivered_back_at = Time.now
    rental.save!

    subject.available = true
    subject.save!
  end

end
