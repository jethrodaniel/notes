class NoteQuery < ApplicationRecord
  self.table_name = :notes_full_text_search
  self.primary_key = :note_id

  belongs_to :note, inverse_of: :full_text_search_query
end
