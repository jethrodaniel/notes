class NotesController < ApplicationController
  before_action :set_note, only: %i[show edit update destroy]

  def index
    query = params[:q]

    user_notes = Note.where(user: Current.user)

    notes = if query.present?
      user_notes.full_text_search(query)
    else
      user_notes.order(updated_at: :desc)
    end

    @pagy, @notes = pagy(notes)

    respond_to do |format|
      format.html
      format.turbo_stream if request_from_notes_index?
    end
  end

  def show
  end

  def edit
  end

  def create
    @note = Note.new(note_params)

    respond_to do |format|
      if @note.save
        format.html { redirect_to edit_note_path(@note), notice: t(".success") }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to notes_path, notice: t(".success") }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @note.destroy!

    respond_to do |format|
      format.html do
        redirect_to notes_path, status: :see_other, notice: t(".success")
      end
    end
  end

  private

  def set_note
    @note = Note.find(params.expect(:id))
  end

  def note_params
    params.expect(note: [:title, :content]).merge(user: Current.user)
  end

  def request_from_notes_index?
    path = Rails.application.routes.recognize_path(request.referer)
    path.slice(:controller, :action) == {controller: "notes", action: "index"}
  end
end
