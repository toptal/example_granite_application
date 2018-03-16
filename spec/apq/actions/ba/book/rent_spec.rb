# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ba::Book::Rent do
  subject(:action) { described_class.as(performer).new(book) }

  let(:available) { true }
  let(:book) { Book.new available: available }
  let(:performer) { User.new }

  describe 'policies' do
    it { is_expected.to be_allowed }

    context 'when user is not authorized' do
      let(:performer) { double }
      it { is_expected.not_to be_allowed }
    end
  end

  describe 'preconditions' do
    it { is_expected.to be_satisfy_preconditions }

    context 'when preconditions fail' do
      let(:available) { false }
      it { is_expected.not_to be_satisfy_preconditions }
    end
  end

  describe '#perform!' do
    specify do
      expect { action.perform! }
        .to change(book, :available).from(true).to(false)
        .and change(Rental, :count).by(1)
    end
  end
end
