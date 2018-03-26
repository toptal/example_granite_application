class Ba::Book::Return < Ba::Book::BusinessAction
  subject :book

  projector :inline

  precondition do
    decline_with(:not_renting) unless rental.present?
  end

  def rental
    @rental ||= performer && performer.rentals.current.find_by(book: book)
  end

  private

  def execute_perform!(*)
    rental.delivered_back_at = Time.now
    subject.available = true
    subject.save!
    rental.save!
  end

end
