class CreateNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :notes, id: :string, default: -> { "uuid()" }, limit: 36 do |t|
      t.text :content, null: false
      t.references :user, null: false, foreign_key: true, type: :string

      t.timestamps
    end
  end
end
