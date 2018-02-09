class AddGenresToBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :genres, :string
  end
end
