class Note < ApplicationRecord
  self.implicit_order_column = :created_at

  belongs_to :user

  after_create_commit :add_to_full_text_search
  after_update_commit :update_full_text_search
  after_destroy_commit :remove_from_full_text_search

  scope :full_text_search, -> query do
    joins("JOIN notes_full_text_search fts ON fts.note_id = notes.id")
      .where(
        "notes_full_text_search MATCH :query",
        query: sanitize_sql_like(query.gsub(/\W/, " ")) + "*"
      )
      .order("bm25(notes_full_text_search)")
  end

  def self.rebuild_full_text_search
    find_each do |note|
      transaction do
        note.remove_from_full_text_search
        note.add_to_full_text_search
      end
    end
  end

  def add_to_full_text_search
    self.class.connection.execute(self.class.sanitize_sql_array([
      <<~SQL.squish, note_id: id, title:, content:
        INSERT INTO notes_full_text_search (note_id, title, content)
        VALUES (:note_id, :title, :content)
      SQL
    ]))
  end

  def update_full_text_search
    self.class.connection.execute(self.class.sanitize_sql_array([
      <<~SQL.squish, title:, content:, note_id: id
        UPDATE notes_full_text_search
        SET
          title = :title,
          content = :content
        WHERE note_id = :note_id
      SQL
    ]))
  end

  def remove_from_full_text_search
    self.class.connection.execute(self.class.sanitize_sql_array([
      "DELETE FROM notes_full_text_search WHERE note_id = :note_id",
      note_id: id
    ]))
  end
end
