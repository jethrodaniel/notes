require "test_helper"

class PreferencesTest < ActiveSupport::TestCase
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
