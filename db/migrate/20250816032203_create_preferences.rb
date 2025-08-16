class CreatePreferences < ActiveRecord::Migration[8.0]
  def change
    create_table :preferences, id: :string, default: -> { "uuid()" }, limit: 36 do |t|
      t.belongs_to :user, null: false, foreign_key: true, index: {unique: true}, type: :string
      t.string :language, null: false

      t.timestamps
    end
  end
end
