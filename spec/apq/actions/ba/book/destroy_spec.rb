# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ba::Book::Destroy do
  subject(:action) { described_class.as(performer).new(book) }

  let(:book) { Book.create }
  let(:performer) { User.new }

  describe 'policies' do
    it { is_expected.to be_allowed }

    context 'when user is not authorized' do
      let(:performer) { double }
      it { is_expected.not_to be_allowed }
    end
  end

  describe '#perform!' do
    before { book }
    specify do
      expect { subject.perform! }.to change { Book.count }.by(-1)
    end
  end
end
