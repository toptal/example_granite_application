require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:valid_attributes) do
    { 'title' => 'Pickaxe Ruby' }
  end

  let(:invalid_attributes) do
    { 'title' => nil }
  end

  describe "GET #index" do
    it "returns a success response" do
      book = Book.create! valid_attributes
      get :index, params: {}
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      book = Book.create! valid_attributes
      get :show, params: {id: book.to_param}
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "does not allow to creat a new Book" do
        expect {
          post :create, params: {book: valid_attributes}
        }.not_to change(Book, :count)
      end

      it "redirects to the books" do
        post :create, params: {book: valid_attributes}
        expect(response).to redirect_to(books_url)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let!(:book) { Book.create! valid_attributes }
      it "updates the requested book" do
        expect do
          put :update, params: {id: book.to_param, book: {title: 'new'}}
        end.not_to change { book.reload.attributes }
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:book) { Book.create! valid_attributes }
    it "destroys the requested book" do
      expect { delete :destroy, params: {id: book.to_param} }.not_to change(Book, :count)
    end

    it "manages error messages if it throws some error destroying" do
      expect_any_instance_of(BA::Book::Destroy).to receive(:perform).and_return(false)
      expect { delete :destroy, params: {id: book.id } }.not_to change(Book, :count)
      expect(flash[:alert]).to eq("Book can't be removed.")
    end

    it "redirects to the books list" do
      delete :destroy, params: {id: book.to_param}
      expect(response).to redirect_to(books_url)
    end
  end

  context 'when signed in' do
    before do
      sign_in User.create
    end

    describe "GET #new" do
      it "returns a success response" do
        get :new, params: {}
        expect(response).to be_success
      end
    end

    describe "GET #edit" do
      it "returns a success response" do
        book = Book.create! valid_attributes
        get :edit, params: {id: book.to_param}
        expect(response).to be_success
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Book" do
          expect {
            post :create, params: {book: valid_attributes}
          }.to change(Book, :count).by(1)
        end

        it "redirects to the created book" do
          post :create, params: {book: valid_attributes}
          expect(response).to redirect_to(Book.last)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: {book: invalid_attributes}
          expect(response).to be_success
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        it "updates the requested book" do
          book = Book.create! title: 'old'
          expect do
            put :update, params: {id: book.to_param, book: {title: 'new'}}
          end.to change { book.reload.title }.from('old').to('new')
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'edit' template)" do
          book = Book.create! valid_attributes
          expect do
            put :update, params: {id: book.to_param, book: invalid_attributes}
          end.not_to change { book.attributes }
          expect(response).to be_success
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested book" do
        book = Book.create! valid_attributes
        expect {
          delete :destroy, params: {id: book.to_param}
        }.to change(Book, :count).by(-1)
      end

      it "redirects to the books list" do
        book = Book.create! valid_attributes
        delete :destroy, params: {id: book.to_param}
        expect(response).to redirect_to(books_url)
      end
    end
  end
end
