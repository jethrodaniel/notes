require "application_system_test_case"

class NotesIndexTest < ApplicationSystemTestCase
  setup do
    @note = notes(:one)

    login_as @note.user
  end

  test "view notes index" do
    visit notes_url

    assert_title "Notes"
    assert_text notes(:one).content
    assert_text notes(:two).content
  end

  test "notes have their content truncated" do
    notes(:one).update! content: "a" * 271 + "hello there general"

    visit notes_url

    assert_text "a" * 271 + "hello ..."
  end

  test "notes show their last update time" do
    freeze_time

    visit notes_url

    assert_text "less than a minute ago", count: 2

    travel_to 1.hour.from_now
    visit notes_url

    assert_text "1 hour ago", count: 2

    notes(:one).update! created_at: 2.hours.ago

    visit notes_url

    assert_text "1 hour ago"
    assert_text "2 hours ago"
  end

  test "notes are ordered by their modification time (most recent first)" do
    freeze_time
    notes(:one).touch # rubocop:disable Rails/SkipsModelValidations

    visit notes_url

    assert_selector "ol>li"
    assert_selector "ol>li:nth-child(1)", text: notes(:one).content
    assert_selector "ol>li>article", id: "note_#{notes(:one).id}"
    assert_selector "ol>li:nth-child(2)", text: notes(:two).content
    assert_selector "ol>li>article", id: "note_#{notes(:two).id}"

    travel_to 5.minutes.from_now
    notes(:two).touch # rubocop:disable Rails/SkipsModelValidations

    visit notes_url

    assert_selector "ol>li"
    assert_selector "ol>li:nth-child(1)", text: notes(:two).content
    assert_selector "ol>li>article", id: "note_#{notes(:two).id}"
    assert_selector "ol>li:nth-child(2)", text: notes(:one).content
    assert_selector "ol>li>article", id: "note_#{notes(:one).id}"
  end
end
