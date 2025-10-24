require "application_system_test_case"

class System::NotesIndexTest < ApplicationSystemTestCase
  setup do
    @note = notes(:one)

    sign_in_as @note.user
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
    notes(:two).touch # rubocop:disable Rails/SkipsModelValidations
    travel_to (1.hour + 5.minutes).from_now
    notes(:one).touch # rubocop:disable Rails/SkipsModelValidations

    visit notes_url

    assert_selector "li",
      id: "note_#{notes(:one).id}",
      text: "Edited less than a minute ago"

    assert_selector "li",
      id: "note_#{notes(:two).id}",
      text: "Edited about 1 hour ago"
  end

  test "notes are ordered by their modification time (most recent first)" do
    freeze_time
    notes(:one).touch # rubocop:disable Rails/SkipsModelValidations

    visit notes_url

    assert_selector "ol>li"
    assert_selector "ol>li:nth-child(1)",
      id: "note_#{notes(:one).id}", text: notes(:one).content
    assert_selector "ol>li:nth-child(2)",
      id: "note_#{notes(:two).id}", text: notes(:two).content

    travel_to 5.minutes.from_now
    notes(:two).touch # rubocop:disable Rails/SkipsModelValidations

    visit notes_url

    assert_selector "ol>li"
    assert_selector "ol>li:nth-child(1)",
      id: "note_#{notes(:two).id}", text: notes(:two).content
    assert_selector "ol>li:nth-child(2)",
      id: "note_#{notes(:one).id}", text: notes(:one).content
  end

  def pagination_setup!
    attrs = Array.new(20 * 2 + 5) do
      {user_id: @note.user.id, content: "pagination"}
    end
    Note.delete_all
    Note.insert_all(attrs) # rubocop:disable Rails/SkipsModelValidations
  end

  test "pagination without javascript" do
    return unless javascript_disabled?

    pagination_setup!

    visit notes_url

    assert_selector "ol>li"
    assert_selector "li>article", count: 20
    assert_link "Load more", href: notes_path(page: 2)

    click_on "Load more"

    assert_current_path notes_path(page: 2)

    assert_selector "ol>li"
    assert_selector "li>article", count: 20
    assert_link "Load more", href: notes_path(page: 3)

    click_on "Load more"

    assert_current_path notes_path(page: 3)

    assert_selector "ol>li"
    assert_selector "li>article", count: 5
    refute_text "Load more"
  end

  test "pagination with javascript (infinite scroll)" do
    return unless javascript_enabled?

    pagination_setup!

    visit notes_url

    assert_selector "ol>li"
    assert_selector "li>article", minimum: 0, maximum: 45
  end
end
