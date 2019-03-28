class CreateWords < ActiveRecord::Migration[5.2]
  def change
    create_table :words do |t|
      t.integer :level
      t.integer :chapter
      t.string :port_word
      t.string :port_word_fem
      t.string :port_word_plural
      t.string :nl_translation
      t.string :genre
      t.text :example

      t.timestamps
    end
  end
end
