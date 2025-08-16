class AddNoteIndexTruncateLengthToPreferences < ActiveRecord::Migration[8.0]
  def change
    add_column :preferences, :note_index_truncate_length, :integer, null: false, default: 280
  end
end
