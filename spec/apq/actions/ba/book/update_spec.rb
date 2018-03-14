# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BA::Book::Update do
  subject(:action) { described_class.as(performer).new(book, attributes) }

  let(:book) { Book.create }
  let(:performer) { User.new }
  let(:attributes) { { 'title' => 'Ruby Pickaxe' } }

  describe 'policies' do
    it { is_expected.to be_allowed }

    context 'when user is not authorized' do
      let(:performer) { double }
      it { is_expected.not_to be_allowed }
    end
  end

  describe 'validations' do
    it { is_expected.to be_valid }

    context 'when preconditions fail' do
      let(:attributes) { {} }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#perform!' do
    specify do
      expect { subject.perform! }.to change(book, :title).from(nil).to('Ruby Pickaxe')
    end
  end
end
