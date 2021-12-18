class RemoveSomeFromArticles < ActiveRecord::Migration[6.1]
  def change
    remove_column :articles, :categories
    remove_column :articles, :language
  end
end
