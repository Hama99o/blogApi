class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :content
      t.string :categories
      t.string :language

      t.timestamps
    end
  end
end
