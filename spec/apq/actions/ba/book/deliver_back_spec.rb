require 'rails_helper'

RSpec.describe BA::Book::DeliverBack do
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
      before { BA::Book::Rent.as(performer).new(book).perform! }
      it { is_expected.to be_satisfy_preconditions }
    end

    context 'when preconditions fail' do
      it { is_expected.not_to be_satisfy_preconditions }
    end
  end

  describe '#perform!' do
    let!(:rental) { BA::Book::Rent.as(performer).new(book).perform! }

    specify do
      expect { action.perform! }
        .to change { book.reload.available }.from(false).to(true)
        .and change { rental.reload.delivered_back_at }.from(nil)
    end
  end
end
