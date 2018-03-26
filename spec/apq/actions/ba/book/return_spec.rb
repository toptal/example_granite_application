require 'rails_helper'

RSpec.describe Ba::Book::Return do
  subject(:action) { described_class.as(performer).new(book) }

  let(:book) { Book.create! title: 'Learn to fly', available: true }
  let(:performer) { User.create! }

  describe 'policies' do
    it { is_expected.to be_allowed }

    context 'when user is not authorized' do
      let(:performer) { double}
      it { is_expected.not_to be_allowed }
    end
  end

  describe 'preconditions' do
    context 'when the user rented the book' do
      before { Ba::Book::Rent.as(performer).new(book).perform! }
      it { is_expected.to be_satisfy_preconditions }
    end

    context 'when preconditions fail' do
      it { is_expected.not_to be_satisfy_preconditions }
    end
  end

  describe '#perform!' do
    let!(:rent_action) { Ba::Book::Rent.as(performer).new(book) }
    before { rent_action.perform!  }

    specify do
      expect { action.perform! }
        .to change { book.reload.available }.from(false).to(true)
        .and change { performer.reload.rentals.current.count}.from(1).to(0)
    end
  end
end
