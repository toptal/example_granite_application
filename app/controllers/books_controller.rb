class BooksController < ApplicationController
  rescue_from Monolith::Action::NotAllowedError do |exception|
    redirect_to books_path, alert: 'You can not do that.'
  end

  # GET /books
  # GET /books.json
  def index
    @books = Book.all
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @book = Book.find(params[:id])
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
  end

  # POST /books
  # POST /books.json
  def create
    book_action = BA::Book::Create.as(current_user).new(book_params)

    respond_to do |format|
      if book_action.perform
        format.html { redirect_to book_action.subject, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: book_action.subject }
      else
        @book = book_action.subject
        format.html { render :new }
        format.json { render json: book_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    @book = Book.find(params[:id])
    book_action = BA::Book::Update.as(current_user).new(@book, book_params)
    respond_to do |format|
      if book_action.perform
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: book_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def book_params
      params.require(:book).to_unsafe_hash.merge(id: params[:id])
    end
end
