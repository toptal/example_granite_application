class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :omniauthable,
  # :recoverable, :rememberable, :trackable, :validatable
  devise :database_authenticatable, :registerable
  has_many :rentals
  has_many :books, through: :rents

  def renting?(book)
    rentals.current.where(id: book.id).exists?
  end
end
