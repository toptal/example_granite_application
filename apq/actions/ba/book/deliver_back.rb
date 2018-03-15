class BA::Book::DeliverBack < BA::Book::BusinessAction

  subject :book

  allow_if { performer.is_a?(User) }

  precondition do
    decline_with(:not_renting) if rental.nil?
  end

  def rental
    @rental ||= Rental.find_by(book: book, user: performer, delivered_back_at: nil)
  end

  private

  def execute_perform!(*)
    rental.delivered_back_at = Time.now
    rental.save!

    subject.available = true
    subject.save!
  end

end
