class AddLanguageToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :language, :string, null: false, default: :en
  end
end
