class CreateSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :sessions, id: :string, default: -> { "uuid()" }, limit: 36 do |t|
      t.references :user, null: false, foreign_key: true, type: :string
      t.string :ip_address
      t.string :user_agent

      t.timestamps
    end
  end
end
