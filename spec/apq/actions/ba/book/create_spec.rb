# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BA::Book::Create do
  subject(:action) { described_class.as(performer).new(attributes) }

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
      expect { action.perform! }.to change { Book.count }.by(1)
    end
  end
end
