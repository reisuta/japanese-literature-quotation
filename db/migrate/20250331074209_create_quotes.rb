class CreateQuotes < ActiveRecord::Migration[8.0]
  def change
    create_table :quotes do |t|
      t.text :content
      t.string :source
      t.string :author
      t.string :work
      t.string :era
      t.string :tags

      t.timestamps
    end
  end
end
