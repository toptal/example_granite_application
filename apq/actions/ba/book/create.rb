class BA::Book::Create < BA::Book::BusinessAction
  def subject
    @subject ||= ::Book.new
  end
end
