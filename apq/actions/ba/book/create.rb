# frozen_string_literal: true

class Ba::Book::Create < Ba::Book::BusinessAction

  def subject
    @subject ||= ::Book.new
  end

  private
  def execute_perform!(*)
    subject.available = true
    super
  end
end
