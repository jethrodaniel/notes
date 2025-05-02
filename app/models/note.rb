class Note < ApplicationRecord
  self.implicit_order_column = :created_at

  belongs_to :user

  # TODO: extract full-text search to a concern eventually

  has_one :full_text_search_query,
    class_name: "NoteQuery",
    inverse_of: :note,
    dependent: :delete

  after_create_commit :add_to_full_text_search
  after_update_commit :update_full_text_search

  scope :full_text_search, -> query do
    search_table = reflect_on_association(
      :full_text_search_query
    ).klass.arel_table

    sanitized_query = query.gsub(/\W/, " ")
    return none if sanitized_query.blank?

    # TODO: search against `title` as well
    match = Arel::Nodes::InfixOperation.new(
      "MATCH",
      search_table[:content],
      Arel::Nodes.build_quoted(sanitized_query + "*")
    )

    joins(:full_text_search_query)
      .where(match)
      .order("bm25(#{search_table.name})")
  end

  def self.rebuild_full_text_search
    search_klass = reflect_on_association(
      :full_text_search_query
    ).klass
    search_klass.delete_all

    find_each do |note|
      note.add_to_full_text_search
    end
  end

  def add_to_full_text_search
    search_klass = self.class.reflect_on_association(
      :full_text_search_query
    ).klass

    self.full_text_search_query = search_klass.new(title:, content:)
  end

  def update_full_text_search
    if full_text_search_query.present?
      full_text_search_query.update(title:, content:)
    else
      add_to_full_text_search
    end
  end
end
