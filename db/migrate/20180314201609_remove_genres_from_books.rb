class RemoveGenresFromBooks < ActiveRecord::Migration[5.1]
  def change
    remove_column :books, :genres
  end
end
