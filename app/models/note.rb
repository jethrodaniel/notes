class Note < ApplicationRecord
  self.implicit_order_column = :created_at

  belongs_to :user

  has_one :full_text_search_query,
    class_name: "NoteQuery",
    dependent: :destroy

  after_create_commit :add_to_full_text_search
  after_update_commit :update_full_text_search

  scope :full_text_search, -> query do
    joins(:full_text_search_query)
      .where(
        "#{NoteQuery.table_name}.content MATCH :query",
        query: query.gsub(/\W/, " ") + "*"
      )
      .order("bm25(#{NoteQuery.table_name})")
  end

  def self.rebuild_full_text_search
    find_each do |note|
      transaction do
        note.add_to_full_text_search
      end
    end
  end

  def add_to_full_text_search
    self.full_text_search_query = NoteQuery.new(title:, content:)
  end

  def update_full_text_search
    full_text_search_query.update(title:, content:)
  end
end
