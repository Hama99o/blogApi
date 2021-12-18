class AddTagsToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :tags, :text
  end
end
