require 'rails_helper'

RSpec.describe BA::Book::Create do
  subject(:action) { described_class.as(performer).new(attributes) }

  let(:performer) { User.new }
  let(:attributes) { { 'title' => 'Ruby Pickaxe', 'genres' => [] } }

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
      let(:attributes) { { } }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#perform!' do
    specify do
      expect { action.perform! }.to change { Book.count }.by(1)
      expect(action.subject.attributes.except('id', 'created_at', 'updated_at')).to eq(attributes)
    end

    context 'when given genres' do
      let(:attributes) do
        {
          'title' => 'Ruby Pickaxe', 'genres' => genres
        }
      end
      let(:genres) { [Genre.new(title: 'Horror'), Genre.new(title:'Science Fiction')] }

      let(:expected_attributes) { { 'title' => 'Ruby Pickaxe', 'genres' => ['Horror', 'Science Fiction'] } }

      it 'creates the book with the given genres' do
        expect { action.perform! }.to change { Book.count }.by(1)
        expect(action.subject.genres).to eq(genres)
        expect(action.subject.reload.attributes.except('id', 'created_at', 'updated_at'))
          .to eq(expected_attributes)
      end

      context 'with nested attributes' do
        let(:attributes) do
          {
            'title' => 'Ruby Pickaxe',
            'genres_attributes' => [{title: 'Horror'}, {title: 'Science Fiction'}]
          }
        end

        it 'creates the book with the given genres' do
          expect { action.perform! }.to change { Book.count }.by(1)
          expect(action.subject.genres).to eq(genres)
          expect(action.subject.reload.attributes.except('id', 'created_at', 'updated_at'))
            .to eq(expected_attributes)
        end
      end
    end
  end
end
