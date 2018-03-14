# frozen_string_literal: true

class BA::Book::Create < BA::Book::BusinessAction
  def subject
    @subject ||= ::Book.new
  end
end
