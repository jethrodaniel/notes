class NoteQuery < ApplicationRecord
  self.table_name = :notes_full_text_search
  self.primary_key = :note_id
  
  belongs_to :note
end
