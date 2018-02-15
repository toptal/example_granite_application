class BA::Book::Destroy < BaseAction
  allow_if { performer.is_a?(User) }

  subject :book

  private

  def execute_perform!(*)
    subject.destroy
  end
end
