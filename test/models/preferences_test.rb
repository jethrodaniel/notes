require "test_helper"

class PreferencesTest < ActiveSupport::TestCase
  class LanguageTests < self
    test "validates language" do
      assert_equal "en", preferences(:one).language
      assert_predicate preferences(:one), :valid?

      assert_equal "es", preferences(:es).language
      assert_predicate preferences(:es), :valid?

      preferences(:one).language = "foo"

      assert_not_predicate preferences(:one), :valid?
      assert_equal ["is not included in the list"],
        preferences(:one).errors[:language]
    end
  end

  class NoteIndexTruncateLengthTests < self
    setup do
      assert_equal 280, preferences(:one).note_index_truncate_length
      assert_predicate preferences(:one), :valid?
    end

    test "validates note_index_truncate_length is a number" do
      preferences(:one).note_index_truncate_length = "foo"

      assert_not_predicate preferences(:one), :valid?
      assert_equal ["is not a number"],
        preferences(:one).errors[:note_index_truncate_length]
    end

    test "validates note_index_truncate_length is greater than 0" do
      preferences(:one).note_index_truncate_length = 0

      assert_not_predicate preferences(:one), :valid?
      assert_equal ["must be greater than 0"],
        preferences(:one).errors[:note_index_truncate_length]
    end
  end
end
