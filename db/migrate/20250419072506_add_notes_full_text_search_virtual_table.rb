class AddNotesFullTextSearchVirtualTable < ActiveRecord::Migration[8.0]
  def change
    create_virtual_table :notes_full_text_search, :fts5, ["note_id", "title", "content"]
  end
end
